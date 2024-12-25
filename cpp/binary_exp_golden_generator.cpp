#define FRACTION_WIDTH -12

#include <iostream>
#include <cmath>
#include <iomanip>
#include <fstream>
using namespace std;

// convert floating point(<1) to 12 bits bianry fixed point
string decimal_to_binary_fixed_point(double decimal){
    int position = -1;
    string result = "";

    while(position >= FRACTION_WIDTH){
        double two_power = pow(2, position);
        if(decimal >= two_power){
            decimal -= two_power;
            result += "1";
        }
        else{
            result += "0";
        }
        position--;
    }

    return result;
}

int main(int argc, char* argv[]){

    fstream fout1, fout2;
    fout1.open(argv[1],ios::out);
    int a1=0,a2=0,a3=0,a4=0,a5=0,a6=0;
 
    // -9.99 to -1.00
    double y1 = -9.99;
    while(y1 < -1.00){
        fout1 << decimal_to_binary_fixed_point(exp(y1)) << endl;
        fout2 << y1 << endl;
        y1 += 0.01;
        a1++;
    }

    // -0.999 tp -0.100
    double y2 = -0.999;
    while(y2 < -0.100){
        fout1 << decimal_to_binary_fixed_point(exp(y2)) << endl;
        y2 += 0.001;
        a2++;
    }

    // -0.0999 to -0.0100
    double y3 = -0.0999;
    while(y3 < -0.0100){
        fout1 << decimal_to_binary_fixed_point(exp(y3)) << endl;
        y3 += 0.0001;
        a3++;
    }

    // -0.00999 to -0.00100
    double y4 = -0.00999;
    while(y4 < -0.00100){
        fout1 << decimal_to_binary_fixed_point(exp(y4)) << endl;
        y4 += 0.00001;
        a4++;
    }

    // -0.000999 to -0.000100
    double y5 = -0.000999;
    while(y5 < -0.000100){
        fout1 << decimal_to_binary_fixed_point(exp(y5)) << endl;
        y5 += 0.000001;
        a5++;
    }

    //-0.0000999 to 0
    double y6 = -0.0000999;
    while(y6 < 0){
        fout1 << decimal_to_binary_fixed_point(exp(y6)) << endl;
        y6 += 0.0000001;
        a6++;
    }

    cout << a1 << " " << a2 << " " << a3 << " " << a4 << " " << a5 << " " << a6 << endl; 
    return 0;
}