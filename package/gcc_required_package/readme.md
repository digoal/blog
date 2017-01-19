```
-- cp to gcc 6.x src dir

-- cd gcc-6.x

tar -zxvf cloog-0.18.4.tar.gz
tar -jxvf gmp-4.3.2.tar.bz2
tar -jxvf isl-0.15.tar.bz2
tar -jxvf mpfr-2.4.2.tar.bz2
tar -zxvf mpc-0.8.1.tar.gz

mv cloog-0.18.4 cloog
mv gmp-4.3.2 gmp
mv mpfr-2.4.2 mpfr
mv mpc-0.8.1 mpc

sed -e 's/isl_stat_ok = 0,/isl_stat_ok = 0/' isl-0.15/include/isl/ctx.h > isl-0.15/include/isl/ctx.h.tem && mv isl-0.15/include/isl/ctx.h.tem isl-0.15/include/isl/ctx.h
mv isl-0.15 isl

cd ..
mkdir objdir
cd objdir
../gcc-6.2.0/configure --prefix=/home/digoal/gcc6.2.0 --disable-isl-version-check --disable-multilib
make -j 32
make install

export LD_LIBRARY_PATH=/home/digoal/gcc6.2.0/lib64:$LD_LIBRARY_PATH  
export LD_RUN_PATH=$LD_LIBRARY_PATH  
export PATH=/home/digoal/gcc6.2.0/bin:$PATH 

vi /etc/ld.so.conf
/home/digoal/gcc6.2.0/lib64

ldconfig
```
