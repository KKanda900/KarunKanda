#include <stdio.h>
#include <stdlib.h>

//Creates an identity matrix based on the original array
/*
Self Note:
Because we are making an identity matrix it has to be a square matrix anyways
*/

double fact;
double fac;
double factor;


void freeM(double**M, int r){
    for(int i = 0; i < r; i++){
        free(M[i]);
    }
    free(M);
}

double** identityMatrix(int row, int cols, double**N){
    //Row and Cols are from the original array
    N = calloc(row, sizeof(double*));
    for(int i = 0; i < row; i++){
        N[i] = calloc(cols, sizeof(double));
        for(int j = 0; j < cols; j++){
            if(i == j){
                N[i][j] = 1.0;
            } else {
                N[i][j] = 0.0;
            }
        }
    }
    return N;
}

//Simplified Gauss Jordan to invert the matrix --> With additional helper functions for ease of use
//Function to invert a matrix (simplified from simple gaussian jordan elimination psuedocode)
double** invert(int rows, double **M, double **N){
    int rowa = rows*2;
    double**augM = calloc(rows, sizeof(double*));
    for(int i = 0; i < rows; i++){
        augM[i] = calloc(rowa, sizeof(double));
        for(int j = 0; j < rowa; j++){
            if(j < rows){
                augM[i][j] = M[i][j];
            } else {
                augM[i][j] = N[i][j - rows];
            }
        }
    }
    for(int i = 0; i < rows; i++){
        fact = augM[i][i];
        for(int j = 0; j < rowa; j++){
            augM[i][j] = augM[i][j]/fact;
        }
        for(int q = 0; q < rows; q++){
            fact = augM[q][i];
            for(int j = 0; j < rowa; j++){
                if(q == i){
                    break;
                }
                double aip = augM[i][j]*fact;
                augM[q][j] = augM[q][j]-aip;
            }
        }

        for(int i = 0; i < rows; i++){
            for(int j = 0; j < rows; j++){
                if(j < rows){
                    N[i][j] = augM[i][rows+j];
                }
            }
        }
    }
    
    freeM(augM, rows);
    return N;
}

//Multiplies two matricies inputs with the same rows and cols or without the same rows and cols
double** multiply(int rows1, int cols2, int row2, double**first, double**second){
    double**result = calloc(rows1,sizeof(double*)); //Future purpose allocated it outside
    for(int i = 0; i < rows1; i++){
        result[i] = calloc(cols2,sizeof(double));
        for(int j = 0; j < cols2; j++){
            for(int k = 0; k < row2; k++){
                result[i][j] += (first[i][k]*second[k][j]); 
            }
        }
    }
    return result;
}

//Transposes the matrix
double** transposeM(int rows, int cols, double**M){
    double**new = calloc(rows, sizeof(double*));
    for(int i = 0; i < rows; i++){
        new[i] = calloc(cols, sizeof(double));
        for(int j = 0; j < cols; j++){
            new[i][j] = M[j][i];
        }
    }
    return new;
}

void printPrices(int rows, double **M){
    for(int i = 0; i < rows; i++){
        printf("%0.0lf\n", M[i][0]); 
    }
}


int main(int argc, char**argv){
    //Next step we got to read the two matricies
    /*
        Input: train matrix and data matrix
        Output: Using the algorithm that is needed to solve, get the estimate
    */

    //Lets work on the first matrix in train.txt
    int rows1;
    int cols1;
    FILE*train = fopen(argv[1], "r");
    if(train == NULL){
        printf("%s\n", "Error");
        exit(1);
    }
    fscanf(train, "%*[^\n]");
    fscanf(train, "%d \n", &cols1);
    fscanf(train, "%d \n", &rows1);
    cols1++;
    double**X = malloc(rows1*sizeof(double*));
    double**Y = malloc(rows1*sizeof(double*));
    for(int i = 0; i < rows1; i++){
        X[i] = malloc(cols1*sizeof(double));
        Y[i] = malloc(1*sizeof(double));
        for(int j = 0; j < cols1 + 1; j++){
            if(j == 0){
                X[i][j] = 1;
            } else if(j == cols1){
                fscanf(train, "%lf", &Y[i][0]);
            } else {
                fscanf(train, "%lf", &X[i][j]);
            }
        }
    }
    fclose(train);

    //Now lets work on the second matrix in data.txt
    int rows2;
    int cols2;
    FILE*data = fopen(argv[2], "r");
    if(data == NULL){
        printf("%s\n", "Error");
        exit(1);
    }
    fscanf(data, "%*[^\n]");
    fscanf(data, "%d \n", &cols2);
    fscanf(data, "%d \n", &rows2);
    cols2++;
    double**Data = malloc(rows2*sizeof(double*));
    for(int i = 0; i < rows2; i++){
        Data[i] = malloc(cols2*sizeof(double));
        for(int j = 0; j < cols2; j++){
            if(j != 0){
                if(j == cols2){
                    fscanf(data, "%lf", &Data[i][j]);
                } else {
                    fscanf(data, "%lf", &Data[i][j]);
                }
            } else {
                Data[i][j] = 1.0;
            }
        }
    }
    fclose(data);

    double**transX = transposeM(cols1, rows1, X);
    double**XTX = multiply(cols1, cols1, rows1, transX, X);
    double**N = identityMatrix(cols1, cols1, XTX);
    double**inv = invert(cols1, XTX, N);
    double**invT = multiply(cols1, rows1, cols1, inv, transX);
    double**W = multiply(cols1, 1, rows1, invT, Y);
    double**P = multiply(rows2, 1, cols1, Data, W);
    printPrices(rows2, P);

    freeM(X, rows1);
    freeM(Y, rows1);
    freeM(Data, rows2);
    freeM(transX, cols1);
    freeM(XTX, cols1);
    freeM(N, cols1);
    freeM(invT, cols1);
    freeM(W, cols1);
    freeM(P, rows2);

    return 0; 
}
