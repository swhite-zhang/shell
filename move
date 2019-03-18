#!/bin/bash

xf=1000
yf=1000
sxf=0
syf=0
xs=4000
ys=4000
sxs=0
sys=0
a=0

upf()
{
syf=`expr $syf + 1`
}
downf()
{
syf=`expr $syf - 1`
}
leftf()
{
sxf=`expr $sxf - 1`
}
rightf()
{
sxf=`expr $sxf + 1`
}

ups()
{
sys=`expr $sys + 1`
}
downs()
{
sys=`expr $sys - 1`
}
lefts()
{
sxs=`expr $sxs - 1`
}
rights()
{
sxs=`expr $sxs + 1`
}

movef()
{
xf=`expr $xf + $sxf`
yf=`expr $yf + $syf`
echo "$xf $yf" > userf.dat
}
moves()
{
xs=`expr $xs + $sxs`
ys=`expr $ys + $sys`
echo "$xs $ys" > users.dat
}

judge()
{
if [[ $xf == 0 || $xf == 5000 ]]; then $sxf =`expr 0 - $sxf`
fi
if [[ $yf == 0 || $yf == 5000 ]]; then $syf =`expr 0 - $syf`
fi
if [[ $xs == 0 || $xs == 5000 ]]; then $sxs =`expr 0 - $sxs`
fi
if [[ $ys == 0 || $ys == 5000 ]]; then $sys =`expr 0 - $sys`
fi
}

echo -e "\033[?25l"
stty -echo
while :
do
read -s -n 1 -t 0.1 a
movef
moves
if [[ $a == "w" ]];then upf
elif [[ $a == "s" ]];then downf
elif [[ $a == "a" ]];then leftf
elif [[ $a == "d" ]];then rightf
elif [[ $a == "i" ]];then ups
elif [[ $a == "k" ]];then downs
elif [[ $a == "j" ]];then lefts
elif [[ $a == "l" ]];then rights
elif [[ $a == "q" ]];then 
stty echo
exit
fi
sleep 0.1

gnuplot <<! 
set terminal pngcairo size 900,900
set output 'user.png'
unset xtics
unset ytics
unset key
set xrange [0:5000]
set yrange [0:5000]
plot 'userf.dat' with circle lc rgb 'green' fs solid 0.5 noborder,\
'users.dat' with circle lc rgb 'red' fs solid 0.5 noborder
set output
exit
!
done
