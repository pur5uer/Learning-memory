在两个月之内开发一个Android app。
假设有60天时间。
做一下计划。
分几个阶段吧。

0、初步想法                                 本周内（2020/3/22之前）
1、学习阶段（学习Android系统及app开发）     20day（2020/4/12之前）
2、设计阶段		                    3day（前20day也可想想）
3、写代码                                   25day（2020/5/7之前）
4、调试修改                                 12day（2020/5/19之前)

以上事项须每天坚持完成。

2020/3/17 今晚解决后顾之忧，先完成审美文化史/数据结构/马原作业，有余力再打打Android代码（21:30之前）。√        √      完成一半 21:17   end

2020/3/18 计组复习or作业/Android跟上进度/构思初步想法（21:30之前)
                ×		half         在想	21:49	end

2020/3/19 计组复习/程序设计复习/Android跟上进度/构思初步想法
		×	×	快了		先写个基础框架比如时钟、社区类app     21:35 end

2020/3/20 计组复习/程序设计复习/android跟上进度/构思初步想法
		×	×		快了	NFC？不太行
	下午复习字符串和模式识别
		√
2020/3/21 构思初步想法  购买了腾讯云服务器并设置了ftp站点  
	  助眠app（图片、动画、音频、视频、闹钟）         23:15 end

2020/3/22 android跟上进度/复习数据结构
				√
2020/4/1 关于各学科，现有状态和进度下，必须采取自学的学科有：计算机组成原理、数据结构与算法、马原、程序设计方法学、中国审美文化史、南京地理文化谈、Android开发。必须远超老师的进度。

2020/4/2 Android开发应使用抽象类和接口


2020/9/26
在图书馆
汇编原理：学到许多
java扫雷：数据结构完美实现了，Main函数功能跳转有重大bug，需要解决重复输入命令的问题。

2020/10/1
物理地址=cs*16 + ip， 在遇到内存单元访问[...]和jmp指令时务必小心

2020/10/2
fro软件密码开门模块初步划分完成。

2020/1/1
scp命令学习：
一、使用SSH连接Linux服务器：
ssh username@Linuxaddress
输入密码：

二、从Linux服务器下载文件（文件夹）到本机
scp username@Linuxaddress:/home/hhn/code C:\Users\Administrator\Desktop
输入密码：

三、从本机上传文件（文件夹）到Linux服务器

scp -r C:\Users\Administrator\Desktop  username@Linuxaddress:/home/hhn/code 
输入密码：
上传到Linux服务器一定要加上-r

makefile文件编写：
makefile的基本格式为“目标:依赖 命令”
一个 makefile 主要含有一系列的规则，如下：
A: B
(tab)<command>
(tab)<command>
重要： 每个命令行前都必须有tab符号
举例来说，一种简单写法如下：
hello: main.o
    gcc -o hello main.o 
main.o : main.c
    gcc -c main.c 

clean:
    rm hello main.o -rf
在终端执行make命令就可以得到main文件了

2021/1/4
设置了默认启动内核

2021/1/5
 Writing speed is 614 M/s
 Reading speed is 2177 M/s
 硬盘写比读快得多

2021/1/18
写词法分析器。
如何处理操作符和分界符？

2021/1/23
shell脚本学习 3页
DNS概念 9页
Web开发概论 mooc 4个视频

2021/1/25
scp 本地文件上传至Virtualbox的linux服务器
scp -P 1111 文件 root@ip:/目录

2021/1/29
修订操作系统实验报告：
①添加内存管理的代码流程图
②添加源代码的注释

2021/2/12
所有教材已加入购物车，一个星期后购买送至学校

每天预习（构建知识网络）：计算机网络、软件体系结构、软件工程，数据库系统原理到学校后再预习

2021/2/21
windows mysql
涉及路径一定要把反斜杠改成正斜杠

环境变量（我的理解）实际上就是把该路径mount到任何目录下

2021/3/12
补漏：
JVM jdbc spring servlet cgi struts awt和swing integer

2021/3/15
Collection接口源码（声明的方法）整理

2021/3/27
每天晚上复习（以前学到的东西）

2021/3/29
看了LinkedList<E>源代码
复习了git命令并提交了2020年写的几个项目

2021/3/30
看了ArrayList<E>的源码

2021/3/31
反射技术粗略（Class、Method、Constructor）
系统学习反射应看java.lang.reflect的文档和代码

2021/4/2
java.lang.reflect初识，包括接口扩展关系、类继承关系，接口AnnotatedElement以及类AccessibleObject文档阅读。

2021/4/6
java.sql文档初步阅读。
网站备案成功。
在Windows Server上：
在IIS上安装了ssl证书并令Http重定向至Https。
在Tomcat上配置ssl证书并且解决了端口8080重定向至端口8443的问题。
——配置server.xml：
	<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" />
	
	<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
	           maxThreads="150" SSLEnabled="true" URIEncoding="UTF-8">
	    <SSLHostConfig>
	        <Certificate certificateKeystoreFile="conf/getheading.xyz.jks"
			 certificateKeystorePassword="czf32604457"
	            type="RSA"/>
	    </SSLHostConfig>
	</Connector>
——配置web.xml：
在</welcome-file-list>后换行并添加：
    <login-config>
<!-- Authorization setting for SSL -->
    <auth-method>CLIENT-CERT</auth-method>
    <realm-name>Client Cert Users-only Area</realm-name>
    </login-config>
    <security-constraint>
<!-- Authorization setting for SSL -->
    <web-resource-collection>
    <web-resource-name>SSL</web-resource-name>
    <url-pattern>/*</url-pattern>
    </web-resource-collection>
    <user-data-constraint>
    <transport-guarantee>CONFIDENTIAL</transport-guarantee>
    </user-data-constraint>
    </security-constraint>
在修改server.xml、web.xml的过程中用git进行了版本控制，其中server.xml版本迭代到了8.0。（QAQ）

2021/4/9
递归实现反转链表
class ListNode {
    int val;
    ListNode next = null;

    ListNode(int val) {
        this.val = val;
    }
    
    /*
     * 反转链表，递归
     * 参数：链表头head
     * 输出：反转后的链表头reHead
     */
    public static ListNode ReverseList(ListNode head) {
    	//考虑0个或一个节点
    	if(head == null || head.next == null)
    		return head;
    	//考虑局部两个节点
    	ListNode reHead = ReverseList(head.next);
    	head.next.next = head;
    	head.next = null;
    	return reHead;
    }
永远检查引用的对象是否为null   

2021/4/10
markdown学习笔记，编辑器为Typora
申请了博客园博客，并将以下内容作为第一篇博客

试试用博客代替手写笔记

# MarkDown学习

## 标题

### 三级标题

#### 四级标题



## 字体

**Hello, World!**

*Hello, World!*

***Hello, World!***

~~Hello, World!~~



## 引用

> 这是一个引用 



## 分割线

---

***



## 图片

![截图1](C:\Users\18751\Pictures\Saved Pictures\www.acg.gy_13.jpg)

![截图2](https://www.getheading.xyz/1/pic/%E8%8A%B1.jpg)



## 超链接

[我的个人网站](https://www.getheading.xyz)



## 列表

1. A
2. B
3. C

- A
- B
- C



## 表格

| 名字 | 性别 | 生日     |
| ---- | ---- | -------- |
| 张三 | 男   | 2000.6.5 |



## 代码

```java
public Class MyClass{
    
}
```



2021/4/11
总结了常用的Dos命令

重新理解了递归（递归头、递归体）。
递归头：什么时候不调用自身方法。如果没有头，将陷入死循环。
递归体：什么时候需要调用自身方法。

总结了多态、接口和抽象类