#include <iostream>
#include <iomanip>
using namespace std;

int main(){
    // inputs = 8 bits integer + 8 bits point (fixed point)
    // outputs = 16 bits integer + 8 bits point
    int A[4][4];
    int B[4][4];
    int product[4][4];

    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++)
            cin >> hex >> A[i][j]; 
    }

    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++)
            cin >> hex >> B[i][j]; 
    }

    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++)
            product[i][j] = 0;
    }

    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++){
            for(int k=0;k<4;k++){
                product[i][j] += A[i][k] * B[k][j];
            }
        }
    }
    
    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++)
            cout << setw(5) << hex << ((product[i][j]/256 >= 65536) ? 65535 : product[i][j]/256) << " ";
        cout << endl;
    }
    return 0;
}