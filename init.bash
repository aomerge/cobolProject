
cd src
gcc -shared -fPIC -o libdbConection.so dbConection.c -lodbc
cd ..

cp ./src/libdbConection.so ./bin/libs

rm ./src/libdbConection.so

cobc -x -free setup.cob -L./bin/libs -ldbConection

cp ./setup ./bin

rm ./setup
cd bin

LD_PRELOAD=$(find ./libs -name '*.so' | tr '\n' ':') ./setup

