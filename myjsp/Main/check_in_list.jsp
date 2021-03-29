<%@ page contentType="text/html;charset=UTF-8" %>

<HTML>
<style>
    input:hover
    {
    background-color:#CDC1C5;
    }
    .d1 {
        padding-top: 15px;
        margin: 150px auto;
        background-color:#96CDCD;
        width:300px;height:160px;
        border-radius:10px;
    }
</style>
    <h1 align="center" fontsize = "10">请填写以下信息</h1>
 <body>
<div  class = "d1" style="">
 <form action="solvelist/add_in.jsp" method="post">
        <table align="center"  class="cell">
    <tr>
		<th>姓名：</th>
        <th><input class="sub" required="required" name="studentname" type="text"></th>
    </tr>
	<tr>
        <th>学号：</th>
        <th><input class="sub" required="required" name="studentid" type="text"></th>
	</tr>
    <tr>
        <th>机位：</th>
        <th><input class="sub"required="required" name="machineid" type="text"></th>
	</tr>
    <tr>
        <th>是否发热：</th>
        <th>是<input type="radio" name="feverstatus" value="1" onclick="show();"></th>　　
　　　　 <th>否<input type="radio" name="feverstatus" value="0" checked onclick="hidd();"></th>
	</tr>
	<tr>
                <th colspan="2">
                    <input class="sub2" type="submit" name="submit" value="登录">
                    <input class="sub2" type="reset" name = "reset" value="重置">
                </th>
	</tr>
        </table>
    </form>
</div>
</body>
 </body></HTML>
