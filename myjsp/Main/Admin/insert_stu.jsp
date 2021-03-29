<%@ page contentType="text/html;charset=UTF-8" %>

<HTML>
<style>
    input:hover
    {
    background-color:#CDC1C5;
    }
    .d1 {
        padding-top: 0px;
        margin: 150px auto;
        background-color:#96CDCD;
        width:300px;height:175px;
        border-radius:10px;
    }
</style>
    <h1 align="center" fontsize = "10">输入要添加的信息</h1>
 <body>
     <%
             request.setCharacterEncoding("utf-8");
             String machineid = request.getParameter("machineid");
     %>
<div  class = "d1" style="">
<form action="insert_stu.jsp" method="post">
</form>
 <form action="search_Stu.jsp" method="post">
    <table align="center"  class="cell">
    <tr>
		<th>姓名：</th>
        <th><input class="sub" required="required" name="studentname" type="text"></th>
    </tr>
    <tr>
		<th>座位号：</th>
        <th><input class="sub" required="required" type="text" name="machineid"></th>
    </tr>
	<tr>
        <th>学号：</th>
        <th><input class="sub" required="required" name="studentid" type="text" ></th>
	</tr>
    <tr>
        <th>是否在线：</th>
        <th>是<input type="radio" name="machinestatus" value="1" onclick="show();"></th>　　
　　　　 <th>否<input type="radio" name="machinestatus" value="0" checked onclick="hidd();"></th>
	</tr>
    <tr>
        <th>是否发热：</th>
        <th>是<input type="radio" name="feverstatus" value="1" onclick="show();"></th>　　
　　　　 <th>否<input type="radio" name="feverstatus" value="0" checked onclick="hidd();"></th>
	</tr>
	<tr>
                <th colspan="2">
                    <input class="sub" type="submit" name="subm" value="提交">
                    <input class="sub" type="reset" name = "reset" value="重置">
                    <input class="sub" type="submit" name = "back" value="返回">
                </th>
	</tr>
        </table>
    </form>
</div>
</body>
 </body></HTML>
