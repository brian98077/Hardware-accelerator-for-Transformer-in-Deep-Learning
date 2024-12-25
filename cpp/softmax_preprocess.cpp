#define NUM 4

#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main(){

    vector<long long int> data(NUM,0);
    
    for(int i=0;i<NUM;i++){
       cin >> hex >> data[i];
    }

    sort(data.begin(), data.end());

    for(int i=0;i<NUM;i++){
       data[i] -= data[NUM-1];
    }

    for(int i=0;i<NUM;i++){
       cout << hex << data[i] << endl;
    }

    return 0;
}