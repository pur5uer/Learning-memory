<%@ page contentType="text/html;charset=UTF-8" %>

<HTML>
    <h1 align="center" fontsize = "10">请填写以下信息</h1>
 <body>
 <form action="/Main/solvelist/add_out.jsp" method="post">
        <table align="left"  class="cell">
    <tr>
		<th>姓名：</th>
        <th><input class="sub" name="studentname" type="text"></th>
    </tr>
	<tr>
        <th>学号：</th>
        <th><input class="sub" name="studentid" type="text"></th>
	</tr>
	<tr>
                <th colspan="2">
                    <input class="sub2" type="submit" name="submit" value="登录">
                    <input class="sub2" type="reset" value="重置">
                </th>
	</tr>
        </table>
</body>
 </body></HTML>
