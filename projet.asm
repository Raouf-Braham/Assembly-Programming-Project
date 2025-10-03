; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt   

Title projet_module  

data segment                  
    
    tab                 db 15 dup(?) ; Declaration d'un tableau de 15 elements non initialise 
    
    msg_saisie          DB 13, 10, 'Donner un caractere a ou b : ', 13, 10, '$' 
    
    msg_erreur          DB 13, 10, 'Erreur !, donner un caractere a ou b : ', 13, 10, '$'
     
    msg_votre_tableau   DB 13, 10, 'Votre Tableau ',32,':',32,'$'                                                   
    
    msg_majoritaire_a   DB 13, 10, 'Le caractere majoritaire ',32,':',32,'a', 13, 10, '$' 
    
    msg_majoritaire_b   DB 13, 10, 'Le caractere majoritaire ',32,':',32,'b', 13, 10, '$'  
 
data ends    

    
code segment        
    
    assume CS:code, DS:data  
    
    
Begin:  

;============================================== Initialisation ===============================================  
    
    mov ax, data  
     
    mov ds, ax    
    
    mov si, offset tab 
    
    mov cx, 15h   
    
    mov al, 0h    
    
          
;============================================== Lecture d'un caractere a ou b =============================================== 
    
    lire_caractere:    
    
        mov dx, offset msg_saisie 
            
        mov AH, 09h    
        
        int 21h   
        
        mov ah, 01h   ; lire un caractere 
        
        int 21h  
         

        ; Test des caracteres et affichage du message d'erreur si necessaire 
         
        test_caractere:           
        
        cmp al, 'a'       
        
        je remplir_tableau 
        
        cmp al, 'b'    
        
        je remplir_tableau      
        

        ; Afficher le message d'erreur 
        
        mov dx, offset msg_erreur  
        
        mov ah, 09h  
        
        int 21h  
        
        mov ah, 01h
         
        int 21h  
         
        ; Demander de re-remplir la case correspondante  
        
        jmp test_caractere  
        

        ; Ajout des caracteres dans le tableau   
        
        remplir_tableau:   
           
        mov tab[si], al 
        
        inc si   

        ; Verifier si on a parcouru tout le tableau   
        
        cmp si, 15     
        
        jae tableau_plein  ; Si oui, sortir de la boucle

        jmp lire_caractere  ; Sinon, continuer a lire un autre caractere 
        
        
        
;============================================== Affichage du tableau ===============================================

    tableau_plein:  
  
            ; Effacer l'ecran     
            
            mov ax, 3  
            
            int 10h  
            
         
            ; Afficher le message "Votre Tableau"   
            
            mov dx, offset msg_votre_tableau 
            
            mov ah, 09h  
            
            int 21h       
            

            ; Afficher le contenu du tableau
            
            mov si, offset tab  
            
            mov cx, 15  ; Taille du tableau  
            
            mov ah, 02h  ; Service d'affichage d'un caractère

            Affichage_Boucle: 
            
                mov dl, [si]  
                
                int 21h

            ; Afficher la barre verticale si ce n'est pas le dernier element  
            
            mov dl, '|'   
            
            int 21h

            inc si  
            

            ; Comparer si avec la fin du tableau  
            
            cmp si, offset tab + 15 
            
            jne Affichage_Boucle

            Fin_Affichage_Boucle:  
            
            ; Retour a la ligne apres l'affichage du tableau  
            
            mov dl, 13   
            
            int 21h
            
            mov dl, 10 
            
            int 21h              
            
                        
;============================================== Compter les occurrences de "a" ===============================================  


        ; Initialisation pour parcourir le tableau  
               
        mov si, offset tab        
        
        xor al, al  ; Initialisation du compteur de caractere "a"
          

        ; Compter les occurrences de "a"  
        
        compter_caracteres_a: 
        
            cmp tab[si], 'a'  
            
            jne caractere_ab_suivant   
            
            ; Incrementer le compteur de caractere "a" 
            
            inc al

        caractere_ab_suivant:
         
            inc si     
            
            cmp si, 15  ; Verifier si on a parcouru tout le tableau. 
            
            jbe compter_caracteres_a  
              
        
        
        cmp al, 8  ; Comparer le nombre d'occurrences de "a" avec la moitie du tableau      
       
            jae a_majoritaire
           
            jb b_majoritaire  
        
        
;============================================== Affichage du resultat ===============================================    

        a_majoritaire:  
        
            ; Afficher "a" est majoritaire 
             
            mov ah, 09h   
            
            mov dx, offset msg_majoritaire_a   
            
            int 21h   
       
            jmp End_program  
            
            
        b_majoritaire:   
        
            ; Afficher "b" est majoritaire   
            
            mov ah, 09h  
             
            mov dx, offset msg_majoritaire_b  
            
            int 21h     
                                            
            jmp End_program  
            
         
;============================================== Fin du programme ===============================================  

    End_program:    
    
        mov ah,4ch  
        
        int 21h    
        
code ends

end Begin
