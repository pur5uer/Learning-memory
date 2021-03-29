assume cs:code,ds:data

;数据段，包括雷区、工作区、输入缓冲区、待显示字符串
data segment
 mine db 16*16 dup(' ')    ;雷区，最大为16*16byte
 workstation db 16*16 dup(' ')    ;工作区，最大为16*16byte
 ;输入缓冲区
 string db 10,0,10 dup(0)
 random db 0            ;随机种子
 scale db 0             ;雷区大小(不超过16)
 percent db 0           ;雷占比(100-x)%
 isminecreated db 0             ;是否已经建立雷区（开始游戏）
 printstatus db '?'     ;打印参数，若为0，正常打印；若为1，打印时遇'*'以' '代之
 tomenu db '?'          ;可以返回菜单的标志，若为1则返回
 west dw 0              ;九宫格边界
 east dw 0
 north dw 0
 south dw 0
 numbs db 0             ;自定义雷数
 iscustom db 0          ;1表示是自定义，0表示不是自定义
 time dw 0              ;最大允许的扫雷时间,单位秒
 origin dd 0            ;初始时间
 now dd 0               ;当前时间
 istimeover db 0        ;时间到为1
 ;待显示字符串
 string0 db 0dh,0ah,'Welcome to Mine!',0dh,0ah
 string1 db 'Put a key to choose function.',0dh,0ah
 string2 db '(n)New Game',0dh,0ah
 string3 db '(c)Continue Game',0dh,0ah
 string4 db '(h)Help',0dh,0ah
 string5 db '(e)Exit',0dh,0ah,'$'
 string6 db 0dh,0ah,'Hello!Before playing,choose a scale of the mine.',0dh,0ah
 string7 db 'Enter coordinates such as 1,1 to clean or mark the mine.Enjoy!',0dh,0ah,'$'
 string7_8 db 0dh,0ah,'Choose a scale of the mine.',0dh,0ah
 string8 db '(e)4*4 (h)6*6 (vh)10*10 (c)Custom (M)Menu',0dh,0ah,'$'
 string9 db 0dh,0ah,'(m)Mark (c)Clean (M)Menu',0dh,0ah,'$'
 string10 db 0dh,0ah,'YOU WIN!',0dh,0ah,'$'
 string11 db 0dh,0ah,'YOU Fail!',0dh,0ah,'$'
 string12 db 0dh,0ah,'Function not found! Try again.',0dh,0ah,'$'
 string13 db 0dh,0ah,'Incorrect input! Try again.',0dh,0ah,'$'
 string14 db 0dh,0ah,'Carefully enter coordinate x and coordinate y to clean the area. Any format you like is ok!',0dh,0ah,'$' 
 string15 db 0dh,0ah,'Enter coordinate x and coordinate y to mark the area.If the area was marked then restore it.',0dh,0ah,'$'
 string16 db 0dh,0ah,'You can not mark a cleaned area!',0dh,0ah,'$'
 string17 db 0dh,0ah,'Restore successful!',0dh,0ah,'$'
 string18 db 0dh,0ah,'Enter scale of mine.',0dh,0ah,'$'
 string19 db 0dh,0ah,'Enter num of bombs.',0dh,0ah,'$'
 string20 db 0dh,0ah,'Enter limited time of game.(0~3600s)',0dh,0ah,'$'
 string21b db 0dh,0ah,'Rest of time:'
 timerest db 4 dup('0')
 string21e db 's',0dh,0ah,'$' 
 string22 db 0dh,0ah,'TIME OVER!',0dh,0ah,'$'
 string23 db 0dh,0ah,'Press any key to continue.',0dh,0ah,'$'
 string24 db 0dh,0ah,'Start a new game fist!',0dh,0ah,'$'
data ends
;代码段
code segment

;子程序 
settime:                ;设置时间
        push ax
        push ds
        push cx
        push bx
        push dx

        mov ax,data
        mov ds,ax
        mov dx,time
        lea bx,string
        mov cl,[bx+1]
        xor ch,ch
makeh:  mov al,[bx+2]         ;转十六进制
        cmp al,'0'
        jb nextnum
        cmp al,'9'
        ja nextnum
        sub al,'0'
        xor ah,ah
        push cx                ;乘法因子计算
        dec cx
        push dx
        cmp cx,0
        jz lastnum
multoh: mov dx,10
        mul dx
        loop multoh             ;以65536为例,首个ax=60000d 
lastnum:               
        pop dx
        pop cx
        add dx,ax
nextnum:
        inc bx
        loop makeh              ;输入转换为十六进制数存入了time
        mov time,dx

setorigin:              ;获得初始时钟
        mov ah,0        ;读时钟计数器值                           
        int 1ah         ;CX:DX＝时钟“滴答”计数,1秒有18.2个“滴答”
        lea bx,origin
        mov [bx],dx
        mov [bx+2],cx

        pop dx
        pop bx
        pop cx  
        pop ds
        pop ax
        ret  

timedeal:               ;根据当前时钟，置timerest和istimeover
        push ax
        push ds
        push bx
        push cx
        push dx
        push si

        mov ax,data
        mov ds,ax

        mov ah,0        ;读时钟计数器值                           
        int 1ah         ;CX:DX＝时钟“滴答”计数 
        lea bx,now
        mov [bx],dx
        mov [bx+2],cx
        lea bx,origin
        mov ax,[bx]
        mov si,[bx+2]
        sub dx,ax
        mov ax,dx
        push ax
        push dx
        mov dl,18               ;得到秒数
        div dl
        pop dx
        mov dl,al               ;送入dx
        xor dh,dh
        pop ax
        sbb cx,si               ;带借位减
        cmp cx,0
        ja timeover
        mov bx,time
        cmp bx,dx
        jb timeover
        sub bx,dx               ;剩余时间16进制数
        mov ax,bx
        lea bx,timerest
        add bx,3
        mov dl,10
toascii:                ;十六进制数转ascii码存入timerest
        div dl
        cmp al,0
        jz lastdeal
        mov cl,ah
        xor ah,ah
        add cl,'0'
        mov [bx],cl             ;余数转ascii码后移入
        dec bx
        jmp toascii

lastdeal:
        mov cl,ah
        add cl,'0'
        mov [bx],cl
        jmp exittimedeal

timeover:
        mov istimeover,1  
exittimedeal:
        pop si
        pop dx
        pop cx
        pop bx
        pop ds
        pop ax
        ret               

mineworkzero:           ;将最大mine和work置' '
        push cx
        push ax
        push ds
        push bx
        push si

        mov ax,data
        mov ds,ax

        mov bx,0

        mov cx,16
s:      push cx
        mov cx,16
        mov si,0
s0:     mov byte ptr [mine+bx+si],' '
        mov byte ptr [workstation+bx+si],' '
        inc si
        loop s0
        pop cx
        add bx,10h
        loop s

        pop si
        pop bx
        pop ds
        pop ax
        pop cx
        ret


showmenu:       ;无参，调用即打印出菜单
        push ax
        push ds
        push dx

        mov ax,data
        mov ds,ax
        lea dx,string0
        mov ah,09h
        int 21h

        pop dx
        pop ds
        pop ax
        ret

showmine:       ;无参，调用即打印出雷区
        push ax
        push ds
        push dx

        mov ax,data
        mov ds,ax
        lea dx,mine
        mov ah,09h
        int 21h

        pop dx
        pop ds
        pop ax
        ret

showworksation:     ;无参，调用即打印出工作区
        push ax
        push ds
        push dx

        mov ax,data
        mov ds,ax
        lea dx,mine
        mov ah,09h
        int 21h

        pop dx
        pop ds
        pop ax
        ret

help:   push ax     ;无参，调用即打印help
        push ds
        push dx

        mov ax,data
        mov ds,ax
        lea dx,String6
        mov ah,09h
        int 21h

        pop dx
        pop ds
        pop ax
        ret 

input:  push ax     ;无参，从键盘上获取一个字符串,存入输入缓冲区
        push ds
        push dx
        push bx

        mov ax,data
        mov ds,ax
        lea dx,string
        mov ah,0ah
        int 21h
      ;  mov al,string+1
      ;  xor ah,ah
      ;  add dx,ax
      ;  mov bx,dx
      ;  mov byte ptr [bx+2],'$'

        pop bx
        pop dx
        pop ds
        pop ax
        ret

menufunc:       ;无参，与input配合使用，根据输入调用菜单所属子程序
        push ax
        push ds
        push bx
        push dx

menuinput:
        call input              ;输入字符选择功能
        mov ax,data
        mov ds,ax
        lea bx,string
        mov ax,[bx+2]           ;ax为输入字符（可能包含回车）
        ;回车符处理
        cmp ah,0dh
        jnz newgame
        xor ah,ah
newgame:
        mov bl,'n'
        xor bh,bh
        cmp ax,bx
        jnz continuegame
        call makemine           ;根据玩家输入初始化雷区并打印
        jmp exitmenu            ;返回
continuegame:   
        mov bl,'c'
        xor bh,bh
        cmp ax,bx
        jnz callhelp
        mov bl,isminecreated
        cmp bl,1
        jnz continuerror
        mov tomenu,0
        call printwork
        jmp exitmenu            ;返回
callhelp:
        mov bl,'h'
        xor bh,bh
        cmp ax,bx
        jnz callexit            ;退出程序
        call help
        call pressanykey                ;按任意键继续
        call showmenu           ;返回主菜单
        jmp short menuinput
        jmp exitmenu            ;返回
callexit:
        mov bl,'e'
        xor bh,bh
        cmp ax,bx
        jnz callerror           ;输入字符非法，提醒玩家重新输入
        call exit
        jmp exitmenu            ;返回
continuerror:
        lea dx,string24
        mov ah,09h
        int 21h
        call showmenu
        jmp short menuinput

callerror:
        lea dx,string12
        mov ah,09h
        int 21h
        call showmenu
        jmp short menuinput
        
exitmenu:
        pop dx        
        pop bx
        pop ds
        pop ax
        ret

makemine:       ;无参，仅被menufunc调用，引导玩家初始化雷区，并将雷区复制到工作区
        push ax
        push ds
        push dx
        push bx

makeinput:
        mov iscustom,0          ;自定义方式置0
        lea dx,string7_8                ;显示选项
        mov ah,09h
        int 21h

        call input              ;输入字符串选择功能
        mov ax,data
        mov ds,ax
        lea bx,string
        mov ax,[bx+2]           ;ax为输入字符（可能包含回车）
        ;回车符处理
        cmp ah,0dh
        jnz easy
        xor ah,ah

easy:   mov bl,'e'
        xor bh,bh
        cmp ax,bx
        jnz hard
        mov bl,4
        mov scale,bl            ;更新雷区大小
        call setmine            ;设置雷区
        call printwork          ;打印工作区
        jmp exitmakemine

hard:   mov bl,'h'
        xor bh,bh
        cmp ax,bx
        jnz veryhard
        mov bl,6               
        mov scale,bl            ;更新雷区大小
        call setmine            ;设置雷区
        call printwork          ;打印工作区
        jmp exitmakemine

veryhard:
        mov bl,'v'
        mov bh,'h'
        cmp ax,bx
        jnz custom        
        mov bl,10
        mov scale,bl            ;更新雷区大小
        call setmine            ;设置雷区
        call printwork          ;打印工作区
        jmp exitmakemine

custom: mov bl,'c'
        xor bh,bh
        cmp ax,bx
        jnz maketomenu
        mov ax,data
        mov ds,ax
        lea dx,string18
        mov ah,09h
        int 21h
        mov ah,1
        int 21h
        sub al,'0'
        mov scale,al            ;设置雷区大小
        lea dx,string19
        mov ah,09h
        int 21h
        mov ah,1
        int 21h
        sub al,'0'
        mov numbs,al            ;设置雷数
        mov bl,scale
        lea dx,string20
        mov ah,09h
        int 21h
        mov time,0
        call input
        call settime
        mov iscustom,1          ;自定义方式置1
        call setmine
        call printwork
        jmp exitmakemine


maketomenu:
        mov bl,'M'
        xor bh,bh
        cmp ax,bx
        jnz makeerror           ;输入字符串非法，提醒玩家重新输入
        mov tomenu,1
        jmp exitmakemine

makeerror:
        lea dx,string12
        mov ah,09h
        int 21h
        jmp makeinput

exitmakemine:
        pop bx
        pop dx
        pop ds
        pop ax
        ret

cancontinue:            ;无参，仅被menufunc调用，判断是否能继续游戏，若失败或未开始，则不可继续并提示且调用input和menufunc，否则调用workfunc


setmine:        ;以bl为行列参数，仅被makemine调用，利用随机数算法初始化雷区，并将雷区复制到工作区
        push ax
        push bx
        push ds
        push si
        push di
        push cx
        push dx
        push es

        call mineworkzero               ;最大置' '
        mov ax,data
        mov ds,ax
        mov es,ax

        lea si,mine             ;ds:si+bx为雷区坐标,si+10h,bx+1h
        xor bh,bh
        mov di,bx
        mov cx,di               ;设置外循环次数
        call getRandom          ;得到随机种子
        mov al,iscustom
        cmp al,1
        jnz outer
        mov dl,numbs
customset:
        cmp dl,0
        jz copy
setit:  call rand
        mov al,scale
        mov dh,random           ;0-99
        mul dh
        mov dh,100
        div dh
        xor ah,ah
        mov bx,ax
        call rand
        mov al,scale
        mov dh,random
        mul dh
        mov dh,100
        div dh
        xor ah,ah
        mov dh,10h
        mul dh
        xor ah,ah
        mov si,ax
        mov al,[mine+si+bx]
        cmp al,'*'
        jz setit
        mov byte ptr [mine+si+bx],'*'
        dec dl
        jmp customset
outer:  push cx
        mov bx,0
        mov cx,di               ;设置内循环次数
inner:  call rand               ;生成0-99随机数，存入random
        cmp random,50           ;设置平均雷数=100-a，a为常数
        jb makeblank
makem:  mov byte ptr [si+bx],'*'
        inc bx
        jmp loopin
makeblank:
        mov byte ptr [si+bx],20h
        inc bx
loopin: loop inner

nextrow:add si,10h              ;下一行
        pop cx
        loop outer              ;循环到此

copy:
        lea ax,mine             ;复制到工作区
        lea bx,workstation
        mov si,ax
        mov di,bx
        sub bx,ax
        mov cx,bx
        cld
        rep movsb

        mov isminecreated,1

exitsetmine:
        pop es
        pop dx
        pop cx
        pop di
        pop si
        pop ds
        pop bx
        pop ax
        ret


workfunc:       ;无参，与input配合使用，根据输入调用工作区所属子程序

printmine:              ;无参，打印雷区
        push ax
        push ds
        push bx

        mov ax,data
        mov ds,ax
        mov printstatus,0                ;printstatus置0
        lea bx,mine
        call printsetup

        pop bx
        pop ds
        pop ax
        ret


printwork:              ;无参，打印工作区，遇到数字、标记、' '打印，遇到'*'打印' '，须打印棋盘'+'、'-'、'|'
        push ax
        push ds
        push bx

        mov ax,data
        mov ds,ax
        mov printstatus,1                ;printstatus置1
        lea bx,workstation
        call printsetup

        pop bx
        pop ds
        pop ax
        ret

printsetup:             ;参数bx，打印地址为ds:bx的雷区或工作区,逐个字符打印
        push ax
        push ds
        push bx
        push dx
        push cx
        push si

        mov ax,data
        mov ds,ax

        call newline    ;打印换行符

        mov cl,scale
        xor ch,ch
        mov al,'0'
        call newblank
coordinatex: 
        call newblank 
        call newblank      
        mov dl,al      ;打印横坐标
        mov ah,2
        int 21h
        inc al
        call newblank
        loop coordinatex
        call newline    ;打印换行符

        mov cl,scale
        xor ch,ch
        call newblank

outdivide0:
        mov dl,'+'      ;交汇处
        mov ah,2
        int 21h
        push cx
        mov cx,3
divide0: 
        mov dl,'-'
        mov ah,2
        int 21h
        loop divide0
        pop cx
        loop outdivide0

        mov dl,'+'      ;交汇处
        mov ah,2
        int 21h

        call newline    ;打印换行符

        mov cl,scale
        xor ch,ch     
        mov al,'0'   

outprint:
        push cx
        mov cl,scale
        xor ch,ch
        mov si,0                ;ds:bx+si为坐标，bx+10h,si+1h

coordinatey:            ;打印纵坐标
        mov dl,al
        mov ah,2
        int 21h

        inc al
        push ax

        mov dl,'|'
        mov ah,2
        int 21h
inprint: 
        call newblank
        cmp printstatus,1
        jnz normal
        mov ah,[bx+si]
        cmp ah,'*'
        jz ignore
        jmp short normal
ignore: call newblank
        jmp short follow        
normal: mov dl,[bx+si]
        mov ah,2
        int 21h
follow: call newblank
        mov dl,'|'
        mov ah,2
        int 21h
        inc si
        loop inprint

        call newline    ;打印换行符

        mov cl,scale    ;打印分行符
        xor ah,ah
        call newblank
outdivide:
        mov dl,'+'      ;交汇处
        mov ah,2
        int 21h
        push cx
        mov cx,3
divide: mov dl,'-'
        mov ah,2
        int 21h
        loop divide
        pop cx
        loop outdivide

        mov dl,'+'      ;交汇处
        mov ah,2
        int 21h

        call newline    ;打印换行符

        pop ax
        pop cx
        add bx,10h
        loop outprint

        pop si
        pop cx
        pop dx
        pop bx
        pop ds
        pop ax
        ret        

pressanykey:            ;无参，实现按任意键继续
        lea dx,string23
        mov ah,09h
        int 21h
        mov ah,0
        int 16h
        ret

newline:push dx         ;无参，打印换行符
        push ax
        mov dl,0ah      ;打印换行符
        mov ah,2
        int 21h 
        pop ax
        pop dx
        ret  

newblank:               ;无参，打印空格
        push dx
        push ax
        mov dl,' '
        mov ah,2
        int 21h
        pop ax
        pop dx
        ret             


iswin:  push ax             ;判断是否获胜，若获胜，打印工作区并祝贺，之后按任意键回到主菜单，若还未获胜，打印工作区后，jmp到parseinput
        push ds                ;判胜条件:工作区的数字数等于雷区空格数
        push bx         ;bx初值为workstation的偏移地址
        push dx
        push di
        push cx

        mov ax,data
        mov ds,ax
        mov al,istimeover
        cmp al,1
        jz timeoverfail
        mov dl,0                ;统计worknum
        mov dh,0                ;统计mineblank

        mov bx,0
        mov cl,scale
        xor ch,ch
cntworknum:
        push cx
        mov cl,scale
        xor ch,ch
        mov di,0                ;统计workstation数字数
cntworkx:        
        mov al,[bx+di+workstation]
        cmp al,'0'
        jb cntworknext
        cmp al,'9'
        ja cntworknext
        inc dl
cntworknext:
        inc di
        loop cntworkx
        add bx,10h 
        pop cx
        loop cntworknum

        mov bx,0
        mov cl,scale
        xor ch,ch
cntmineblank:
        push cx
        mov cl,scale
        xor ch,ch
        mov di,0                ;统计mine中空格数
cntminex:        
        mov al,[bx+di+mine]
        cmp al,' '
        jnz cntminenext
        inc dh
cntminenext:
        inc di
        loop cntminex
        add bx,10h 
        pop cx
        loop cntmineblank

        cmp dl,dh
        jnz notwin
win:    call printwork
        lea dx,string10
        mov ah,09h
        int 21h
        call pressanykey
        mov tomenu,1
        mov isminecreated,0
        jmp short exitiswin
timeoverfail:
        lea dx,string22
        mov ah,09h
        int 21h
        call pressanykey
        mov tomenu,1
        mov isminecreated,0
        jmp short exitiswin
notwin: call printwork

exitiswin:
        pop cx
        pop di
        pop dx
        pop bx
        pop ds
        pop ax
        ret

getRandom:              ;无参，得到随机种子
        push ax                                                 
        push cx 
        push dx                                                
                                                                
        sti             ;if=1，开中断                            
        mov ah,0        ;读时钟计数器值                           
        int 1ah         ;CX:DX＝时钟“滴答”计数                                                 
        mov ax,dx
        mov random,al       

        pop dx
        pop cx
        pop ax
        ret


rand:           ;无参，产生0-99的随机数存入random，缺点是除以100有可能产生很有规律的雷区
        push ax
        push bx

        mov al,random
        mov bl,17
        mul bl
        add ax,139
        mov bl,100
        div bl
        mov random,ah

        pop bx
        pop ax
        ret

gamecore:               ;选择clean、mark或menu
        push ax
        push dx
        push ds
        push bx
        
gameinput:
        mov ax,data
        mov ds,ax
        lea dx,string9          ;打印功能选择
        mov ah,09h
        int 21h
        mov al,iscustom
        cmp al,1
        jnz inputg
        call timedeal
        lea dx,string21b        ;打印剩余时间
        mov ah,09h
        int 21h
inputg:
        call input

        lea bx,string
        mov ax,[bx+2]           ;ax为输入字符（可能包含回车）
        ;回车符处理
        cmp ah,0dh
        jnz callclean
        xor ah,ah
callclean:
        mov bl,'c'
        xor bh,bh
        cmp ax,bx
        jnz callmark
        lea dx,string14         ;提示输入
        mov ah,09h
        int 21h
        call clean
        cmp tomenu,1
        jz exitgamecore
        jmp short gameinput
callmark:
        mov bl,'m'
        xor bh,bh
        cmp ax,bx
        jnz callmenu
        lea dx,string15         ;提示用户
        mov ah,09h
        int 21h
        call mark
        cmp tomenu,1
        jz exitgamecore
        jmp short gameinput
callmenu:
        mov bl,'M'
        xor bh,bh
        cmp ax,bx
        jnz errorinput
        mov tomenu,1
        jmp short exitgamecore
errorinput:
        lea dx,string12
        mov ah,09h
        int 21h
        jmp gameinput


exitgamecore:        
        pop bx
        pop ds
        pop dx
        pop ax
        ret

clean:          ;根据输入探测雷区坐标。若有雷，失败；若无雷，改写workstation该坐标值为周围雷数，若该值为0，扫出一片
        push ax
        push ds
        push bx
        push cx
        push dx
        push di

        mov ax,data
        mov ds,ax

parseinput:
        call input
        call parsecordinate             ;解析缓冲区，提取x、y坐标到di、bx
        cmp di,'?'              ;是否解析失败
        jz parseinput 

        sub bx,'0'
        sub di,'0'
        mov ax,bx                ;得到坐标地址转换为数字后,x坐标不变,y坐标乘以10h
        mov al,10h
        mul bl          ;ax为y坐标
        mov bx,ax
        mov al,[bx+di+mine]               ;坐标内容
        cmp al,'*'
        jz callfail
        jmp short nomine
callfail:               ;踩雷，显示失败提醒并打印完整雷区之后按任意键回到主菜单
        call fail       
        call pressanykey
        mov tomenu,1
        jmp short exitclean

nomine:        ;无雷,改写workstation相应坐标位置值为周围雷数，如果为0，扫出一片
        call cnt                ;统计坐标周围雷数，存入dl
        add dl,'0'              ;转ascii码
        cmp dl,'0'              ;判断是否为'0'
        mov [bx+di+workstation],dl               ;改写workstation相应坐标位置值
        ;jz iszero
        call iswin                ;判断是否获胜，若获胜，打印工作区并祝贺，之后按任意键回到主菜单，若还未获胜，打印工作区后，jmp到gameinput
        jmp short exitclean
iszero:                         ;用dl计数当dl不为0时停止
        call zero               ;扫出一片
        call printwork




exitclean:   
        pop di
        pop dx
        pop cx
        pop bx
        pop ds
        pop ax
        ret

mark:   push ax
        push ds
        push bx
        push cx
        push dx
        push di

        mov ax,data
        mov ds,ax

parsemark:
        call input
        call parsecordinate             ;解析缓冲区，提取x、y坐标到di、bx
        cmp di,'?'              ;是否解析失败
        jz parsemark 

        sub bx,'0'
        sub di,'0'
        mov ax,bx                ;得到坐标地址转换为数字后,x坐标不变,y坐标乘以10h
        mov al,10h
        mul bl          ;ax为y坐标
        mov bx,ax
        mov cl,[workstation+di+bx]              ;还原
        cmp cl,'!'
        jz restore
        cmp cl,'0'
        jb themark
        cmp cl,'9'
        ja themark
        jmp short markfail
themark:
        mov byte ptr [workstation+di+bx],'!'            ;标记
        jmp short exitmark
restore:
        mov cl,[mine+di+bx]
        mov [workstation+di+bx],cl
        lea dx,string17
        mov ah,09h
        int 21h
        jmp short exitmark  
markfail:
        lea dx,string16
        mov ah,09h
        int 21h

exitmark:
        call printwork
        pop di
        pop dx
        pop cx
        pop bx
        pop ds
        pop ax
        ret


zero:   jmp short exitret               ;有bug先跳过
        push dx         ;[bx+di+workstation]为坐标，dl初值为0，表示此坐标周围无雷，north、south、west、east为边界
        push ax         ;扫出一片
        push cx
        push bx
        push di

        mov al,dl
        add al,'0'
        mov byte ptr [workstation+bx+di],al
        cmp dl,0
        jnz exitzero
        pop ax          ;挖空,否则陷入死循环
        pop cx
        cmp di,ax
        jz exitzero
        cmp bx,cx
        jz exitzero

        mov ax,south
        mov cx,north
        sub ax,cx
        mov cl,10h              ;除10处理
        div cl
        xor ah,ah
        mov cx,ax
        inc cx          ;外循环
        mov di,west             ;(x,y)置为(west,north)
        mov bx,north
zeroout:push cx
        mov cx,east
        mov ax,west
        sub cx,ax
        inc cx          ;内循环
zeroin: call cnt                ;此处修正了n、s、w、e、dl
        call zero               ;若dl不为0直接返回
        inc di
        loop zeroin
        pop cx
        add bx,10h
        loop zeroout


exitzero:
        push cx
        push ax
        pop di
        pop bx
        pop cx
        pop ax
        pop dx
exitret:
        ret


cnt:    push ax         ;统计坐标对应workstation地址(bx+di+workstation)的mine周围雷数存入dl
        push bx
        push ds
        push di
        push cx
        
        mov ax,data
        mov ds,ax
        mov ax,10h              ;ax为y最大值
        mul scale
        mov dl,scale            ;将scale存入dx
        xor dh,dh
left:   cmp di,0                ;确定须统计九宫格边界west、east、north、south
        mov west,di
        jz right
        dec di
        mov west,di
        inc di
right:  cmp di,dx  
        mov east,di
        jz up
        inc di
        mov east,di
        dec di
up:     cmp bx,0
        mov north,bx
        jz down
        sub bx,10h
        mov north,bx
        add bx,10h
down:   cmp bx,ax
        mov south,bx
        jz loopcnt         
        add bx,10h
        mov south,bx
        sub bx,10h

loopcnt:mov dl,0
        mov cx,south
        mov ax,north
        sub cx,ax       
        mov ax,cx
        mov cl,10h
        div cl
        mov cl,al               ;cx=(south-north)/10h
        xor ch,ch
        inc cx
        mov di,west             ;(x,y)置为(west,north)
        mov bx,north
cnty:   push cx
        mov cx,east
        mov ax,west
        sub cx,ax               ;cx=east-west
        inc cx
cntx:   mov al,[bx+di+mine]
        cmp al,'*'
        jnz nextx
        inc dl
nextx:  inc di
        loop cntx 
        mov di,west             ;x归左边界
        pop cx
        add bx,10h              ;y=y+1
        loop cnty               ;循环,循环结束后di=east,bx=south,dl为雷数

        pop cx
        pop di
        pop ds
        pop bx
        pop ax
        ret


fail:   push ax
        push dx
        push ds

        mov ax,data
        mov ds,ax

        call printmine          ;显示雷区

        lea dx,string11         ;提示失败
        mov ah,09h
        int 21h

        mov isminecreated,0

        pop ds
        pop dx
        pop ax
        ret


parsecordinate:
        push ax
        push ds
        push si
        push cx
        push dx 

        mov ax,data
        mov ds,ax
        lea bx,string           ;dx为缓冲区地址;ds:bx+si+di表示缓冲区，bx为首地址,si*10h为纵坐标,di为横坐标
        mov si,'?'
        mov di,'?'
        
        mov cl,[bx+1]                ;解析缓冲区，将横纵坐标存入di、si
        xor ch,ch
parse:  mov al,[bx+2]          ;si初值为2，+1h用来遍历缓冲区
        mov ah,[bx+3]                ;向后看一个字符
        mov dl,[bx+4]           ;向后看两个字符,避免三个连续数字输入如：354,789 
        cmp al,'0'              ;小于'0'和大于'9'的处理
        jb parsenext
        cmp al,'9'
        ja parsenext
        cmp ah,'0'         ;在第一个字符为数字的前提下
        jb parsesingle
        cmp dl,'0'              ;在前两个字符都为数字的前提下
        jb parsedouble
        cmp dl,'9'
        ja parsedouble
        cmp ah,'9'
        ja parsesingle
        cmp dl,'0'              ;在前两个字符都为数字的前提下
        jb parsedouble
        cmp dl,'9'
        ja parsedouble
        jmp short parsefail             ;连续输入三个数字字符，失败

parsedouble:            ;如果输入的坐标大于10
        cmp di,'?'              ;如果横坐标已提取
        jnz parsedoubley
        mov di,[bx+2]          ;提取横坐标
        dec cx          ;由于多移入一个字符，cx须减一
        add bx,2
        jmp short parseloop                
parsedoubley: 
        mov si,[bx+2]          ;如果能运行至此，则y必然为10以上
        dec cx          ;由于多移入一个字符，cx须减一
        jmp short parseloop 


parsesingle:            ;如果输入的坐标小于10
        cmp di,'?'              ;如果横坐标已提取，转向纵坐标
        jnz parsesingley 
        mov dl,[bx+2]          ;提取横坐标
        xor dh,dh
        mov di,dx
        inc bx
        jmp short parseloop 
parsesingley:
        mov dl,[bx+2]          ;提取纵坐标
        xor dh,dh
        mov si,dx
        jmp short parseloop                       

parsenext:
        inc bx

parseloop:        
        loop parse
        mov bx,si
        cmp di,'?'              ;输入非法
        jz parsefail
        cmp bx,'?'
        jz parsefail
        mov al,scale            ;越界判定
        xor ah,ah
        add al,'0'              ;转ascii码
        cmp di,ax
        ja parsefail
        cmp bx,ax
        ja parsefail
        jmp short exitparsecordinate

parsefail:
        mov di,'?'              ;返回一个输入非法的标志,并提示用户重新输入
        lea dx,string13
        mov ah,09h
        int 21h


exitparsecordinate:
        pop dx
        pop cx
        pop si
        pop ds
        pop ax
        ret        


exit:   mov ax,4c00h    ;无参，调用即退出程序
        int 21h       

;测试程序
pt:     mov ax,data
        mov ds,ax

menu0:  mov tomenu,'?'          ;重置tomenu
        call showmenu
        call menufunc
        cmp tomenu,1
        jz menu0
        call gamecore
        cmp tomenu,1
        jz menu0
        call exit
       ;call input               ;测试时间
       ;call settime
       
;主程序
start:  mov ax,data
        mov ds,ax

menu:   mov tomenu,'?'          ;重置tomenu
        call showmenu
        call menufunc
        cmp tomenu,1
        jz menu
        call gamecore
        cmp tomenu,1
        jz menu
        call exit
code ends

end start
