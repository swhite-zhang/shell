#user数组0-x，1-y，2-vx，3-vy，4-ax，5-ay，6-r，7-m，8-n

move(){${user1[*]} ${user2[*]} ${user3[*]} ${user4[*]}
#user变量用来存放小车的位置、速度、加速度、半径、质量、是否已经计算碰撞
if $user1[8] -eq 0
then
$user1[0]=$user1[0]+$user1[2]
$user1[1]=$user1[1]+$user1[3]
fi
if $user2[8] -eq 0
then
$user2[0]=$user2[0]+$user2[2]
$user2[1]=$user2[1]+$user2[3]
fi
if $user3[8] -eq 0
then
$user3[0]=$user3[0]+$user3[2]
$user3[1]=$user3[1]+$user3[3]	
fi
if $user4[8] -eq 0
then
$user4[0]=$user4[0]+$user4[2]
$user4[1]=$user4[1]+$user4[3]
fi
#更新小车位置
}

speed(){${user1[*]} ${user2[*]} ${user3[*]} ${user4[*]}
$user1[2]=$user1[2]+$user1[4]
$user1[3]=$user1[3]+$user1[5]
$user2[2]=$user2[2]+$user2[4]
$user2[3]=$user2[3]+$user2[5]
$user3[2]=$user3[2]+$user3[4]
$user3[3]=$user3[3]+$user3[5]
$user4[2]=$user4[2]+$user4[4]
$user4[3]=$user4[3]+$user4[5]
#更新小车速度
}

crash（${ball1[*]} ${ball2[*]}）{
if expr (($ball1[0]+$ball1[2])-($ball2[0]+$ball2[2]))**2+(($ball1[1]+$ball2[3])-($ball2[1]+$ball2[3]))**2 -le ($ball1[6]+$ball2[6])**2
then
k1=`expr $ball1[1]/$ball1[0]`
k2=`expr $ball2[1]/$ball2[0]`
y=`echo "scale=8;($(k2)*ball1[1]-$(k1)*ball2[1]-$k1*$k2*(ball1[0]-ball2[0]))/($k2-$k1)"|bc`
x=`echo "scale=8;($y-$ball1[1])/$k1+ball1[0]"|bc`”
#计算碰撞路线交点
#until $n -eq 5 || $error -le 0.01
#do
#dot1x=($ball1[0]+$x)/2
#dot1y=($ball1[1]+$y)/2
#dot2x=($ball2[0]+$x)/2
#dot2y=($ball2[0]+$y])/2
local dip1x=$ball1[0]-$x
local dip1y=$ball1[1]-$y
local dip2x=$ball2[0]-$x
local dip2y=$ball2[1]-$x
#目前坐标于交点的距离
local i=1
local j=1
local k=1
error[25]
for i in 1 2 3 4 5
do
for j in 1 2 3 4 5
do
error[($j-1)+5*($i-1)]=` echo "scale=8;（$x+$i*$dip1x-($x+$j*$ dip2x)）**2+($y+$i*$dip1y-($y+$j*$ dip2y))**2-$ball1[6]**2-$ball2[6]**2"|bc`
$j=$j+1
done
$i=$i+1
$j=0
done
while $k -le 24
do
if $error[$k] -lt 0
then $error[$k]=-$error[$k]
fi
done
$i=1
$j=0
while $i -le 24
do
$serror=$error[0]
if $vserror -lt $error[i]
then $serror=$error[i]
$j=$i
fi
$i=$i+1
done
#枚举逼近碰撞点
$i=($j+1)/5
$j=($j+1)%5
p1x=$x+$i*$dip1x
p1y=$y+$i*$dip1y
p2x=$x+$j*$ dip2x
p2y=$y+$j*$ dip2y
#这是拟合出碰撞时两个球球心的位置
local t=($p1x-$ball1[0])/ball1[2]
#计算碰撞前运动时间
$k=`echo "scale=8;($p1y-$p2y)/($p1x-$p2x) "|bc`
$k_=-1/$k
#计算碰撞径向与轴向
sinx=`echo "scale=8;(1/sqrt((1/$k_)**2+1))"|bc`
cosx=`echo "scale=8;(1/sqrt(($k_)**2+1))"|bc`
#计算正弦和余弦
local v1=$ball1[0]*$sinx+$ball1[1]*$cosx
local v2=$ball2[0]*$sinx+$ball2[1]*$cosx
#此处暂以交换速度为碰撞
local v1x=$v1*$sinx
local v2x=$v2*$sinx
local v1y=$v1*$cosx
local v2y=$v2*$cosx
$ball1[2]=$ball1[2]-v1x+v2x
$ball1[3]=$ball1[3]-v1y+v2y
$ball2[2]=$ball2[2]+v1x-v2x
$ball2[3]=$ball2[3]+v1y-v2y
#更新速度
$t=1-$t
$ball1[0]= $p1x+$t*$ball1[2]
$ball1[1]= $p1y+$t*$ball1[3]
$ball2[0]= $p2x+$t*$ball2[2]
$ball2[1]= $p2y+$t*$ball2[3]
#更新位置
ball1[8]=1
ball2[8]=1
#表明已经碰撞
#`echo "scale=8;sqrt(2)"|bc`
fi
}

crash_wall(ball[]){
local t=1
#碰撞时间
if $ball[0]+$ball[2]+ball[7] -ge $x_range
then 
$t=($x-range_ball[0])/ball[2]
$t=1-$t
ball[2]=-ball[2]
$ball[0]=x_range-$t*ball[2]
ball[8]=1

elif $ball[0]+$ball[2]+ball[7] -le -$x_range
then
$t=(ball[0]-$x_range)/ball[2]
$t=1-$t
ball[2]=-ball[2]
$ball[0]=-x_range+$t*ball[2]
ball[8]=1

elif $ball[1]+$ball[3]+ball[7] -ge $y_range
then
$t=($x-range_ball[1])/ball[3]
$t=1-$t
ball[3]=-ball[3]
$ball[1]=y_range-$t*ball[3]
ball[8]=1

elif $ball[1]+$ball[3]+ball[7] -le -$y_range
then
$t=(ball[1]-$x_range)/ball[3]
$t=1-$t
ball[3]=-ball[3]
$ball[1]=-y_range+$t*ball[3]
ball[8]=1

fi
#边界碰撞函数
}


up1()
	{
	user1[5]=`expr $user1[5] + 0.2`
	}
	down1()
	{
	user1[5]=`expr $user1[5] – 0.2`
	}
	left1()
	{
	user1[4]=`expr $user1[4] - 0.2`
	}
	right1()
	{
	user1[4]=`expr $user1[4] + 0.2`
	}
	

	up2()
	{
	user2[5]=`expr $user2[5] + 0.2`
	}
	down2()
	{
	user2[5]=`expr $user2[5] - 0.2`
	}
	left2()
	{
	user2[4]=`expr $user2[4] - 0.2`
	}
	right2()
	{
	user2[4]=`expr $user2[4] + 0.2`
	}
up3()
	{
	user3[5]=`expr $user3[5] + 0.2`
	}
	down3()
	{
	user3[5]=`expr $user3[5] - 0.2`
	}
	left3()
	{
	user3[4]=`expr $user3[4] - 0.2`
	}
	right3()
	{
	user3[4]=`expr $user3[4] + 0.2`
	}
	

	up4()
	{
	user4[5]=`expr $user4[5] + 0.2`
	}
	down4()
	{
	user4[5]=`expr $user4[5] - 0.2`
	}
	left4()
	{
	user4[4]=`expr $user4[4] - 0.2`
	}
	right4()
	{
	user4[4]=`expr $user4[4] + 0.2`
	}

echo -e "\033[?25l"
	stty -echo
	while :
	do
	read -s -n 1 -t 0.1 a
	movef
	moves
	if [[ $a == "w" ]];then up1
if[[  ]]
	elif [[ $a == "s" ]];then down1
	elif [[ $a == "a" ]];then left1
	elif [[ $a == "d" ]];then right1
	elif [[ $a == "i" ]];then up2
	elif [[ $a == "k" ]];then down2
	elif [[ $a == "j" ]];then left2
	elif [[ $a == "l" ]];then right2
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







