; You may customize this and other start-up templates
; The location of this template is c:\emu8086\inc\0_com_template.txt   

Title project_module  

data segment                  
    
    tab                 db 15 dup(?) ; Declaration of an array of 15 uninitialized elements
    
    msg_saisie          DB 13, 10, 'Enter a character a or b: ', 13, 10, '$' 
    
    msg_erreur          DB 13, 10, 'Error! Enter a character a or b: ', 13, 10, '$'
     
    msg_votre_tableau   DB 13, 10, 'Your Array ',32,':',32,'$'                                                   
    
    msg_majoritaire_a   DB 13, 10, 'The majority character ',32,':',32,'a', 13, 10, '$' 
    
    msg_majoritaire_b   DB 13, 10, 'The majority character ',32,':',32,'b', 13, 10, '$'  
 
data ends    

    
code segment        
    
    assume CS:code, DS:data  
    
    
Begin:  

;============================================== Initialization ===============================================  
    
    mov ax, data  
    mov ds, ax    
    
    mov si, offset tab 
    mov cx, 15h   
    mov al, 0h    
    
          
;============================================== Reading a character a or b =============================================== 
    
    lire_caractere:    
    
        mov dx, offset msg_saisie 
        mov AH, 09h    
        int 21h   
        
        mov ah, 01h   ; Read a character
        int 21h  
         
        ; Test characters and display error message if necessary 
         
        test_caractere:           
        
        cmp al, 'a'       
        je remplir_tableau 
        
        cmp al, 'b'    
        je remplir_tableau      
        
        ; Display error message 
        mov dx, offset msg_erreur  
        mov ah, 09h  
        int 21h  
        
        mov ah, 01h   ; Read again
        int 21h  
         
        ; Ask again to fill the corresponding array element  
        jmp test_caractere  
        

        ; Add characters into the array   
        remplir_tableau:   
           
        mov tab[si], al 
        inc si   

        ; Check if the entire array has been filled   
        cmp si, 15     
        jae tableau_plein  ; If yes, go to display

        jmp lire_caractere  ; Otherwise, continue reading 
        
        
;============================================== Display the array ===============================================

    tableau_plein:  
  
            ; Clear screen     
            mov ax, 3  
            int 10h  
            
            ; Display the message "Your Array"   
            mov dx, offset msg_votre_tableau 
            mov ah, 09h  
            int 21h       
            
            ; Display the content of the array
            mov si, offset tab  
            mov cx, 15  ; Size of array  
            mov ah, 02h  ; Print character service

            Affichage_Boucle: 
            
                mov dl, [si]  
                int 21h

                ; Display vertical bar if not the last element  
                mov dl, '|'   
                int 21h

                inc si  
            
                ; Compare with the end of the array  
                cmp si, offset tab + 15 
                jne Affichage_Boucle

            Fin_Affichage_Boucle:  
            
            ; New line after displaying array  
            mov dl, 13   
            int 21h
            mov dl, 10 
            int 21h              
            
                        
;============================================== Count the occurrences of "a" ===============================================  

        ; Initialization to loop through the array  
        mov si, offset tab        
        xor al, al  ; Initialize counter for 'a'
          
        ; Count occurrences of "a"  
        compter_caracteres_a: 
        
            cmp tab[si], 'a'  
            jne caractere_ab_suivant   
            
            ; Increment counter for 'a' 
            inc al

        caractere_ab_suivant:
         
            inc si     
            cmp si, 15  ; Check if entire array is scanned
            jbe compter_caracteres_a  
              
        cmp al, 8  ; Compare number of 'a' occurrences with half the array      
       
            jae a_majoritaire
            jb b_majoritaire  
        
        
;============================================== Display result ===============================================    

        a_majoritaire:  
        
            ; Display "a is majority"  
            mov ah, 09h   
            mov dx, offset msg_majoritaire_a   
            int 21h   
            jmp End_program  
            
            
        b_majoritaire:   
        
            ; Display "b is majority"   
            mov ah, 09h  
            mov dx, offset msg_majoritaire_b  
            int 21h     
            jmp End_program  
            
         
;============================================== End of program ===============================================  

    End_program:    
    
        mov ah,4ch  
        int 21h    
        
code ends

end Begin