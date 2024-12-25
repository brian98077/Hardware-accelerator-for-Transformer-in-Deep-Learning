#include <iostream>
#include <iomanip>
#include <fstream>
using namespace std;

int main(int argc, char* argv[]){
    // inputs = 8 bits integer + 8 bits point (fixed point)
    // outputs = 16 bits integer + 8 bits point
    long long int A[4][4];
    long long int B[4][4];
    long long int product[4][4];

    fstream fin_A(argv[1]);
    fstream fin_B(argv[2]);
    fstream fout;
    fout.open(argv[3],ios::out);

    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++)
            fin_A >> hex >> A[i][j]; 
    }

    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++)
            fin_B >> hex >> B[i][j]; 
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
            fout << setw(6) << hex << ((product[i][j]/256 >= 16777216) ? 16777215 : product[i][j]/256) << " ";
        fout << endl;
    }
    return 0;
}