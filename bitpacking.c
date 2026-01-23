#include <stdio.h> 
#include <stdlib.h>
void set(char* sel, int n){
    *sel = *sel | (1<<n);
}
void clear(char* sel, int n){
    *sel = *sel & ~(1<<n);
}
void toggle(char* sel, int n){
    *sel = *sel ^ (1<<n);
}

int print(char* sel, int n){
    return 1 & (*sel >> n);
}

int main(){
    char selector = 0b10100001;
    while(1){
        int glob;
        printf("\nvalues:");
        printf("\n7 6 5 4 3 2 1 0");
        printf("\n");
        for(glob = 7; glob>= 0; glob--)
            printf("%d ", print(&selector,glob));
        
        printf("\n1. set");
        printf("\n2. reset");
        printf("\n3. toggle");
        printf("\n4. print");
        printf("\n5. exit");
        printf("\nSelect an option: ");
        scanf("%d", &glob);

         system("cls");
        system("clear");

        printf("\nSelect bit to operate:");
        int bit;
        scanf("%d", &bit);
        switch (glob){
        case 1:
            set(&selector,bit);
            break;
        case 2:
            clear(&selector,bit);
            break;
        case 3:
            toggle(&selector,bit);
            break;
        case 4:
            printf("\nvalue %d: %d",bit, print(&selector,bit));
            break;
        case 5:
            return 0;
        default:
            printf("Selecione outra opção");
            break;
        }
    }
}   

// 0 0 0 1 <<
//       2
// -------
// 0 1 0 0


// 0 1 0 0 ~
// -------
// 1 0 1 1

// 1 1 0 1 &
// 1 0 1 1
// -------
// 1 0 0 1