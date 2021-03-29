<%@ page contentType="text/html; charset=utf-8" errorPage="" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="mystyle.css">
    <title>登陆界面</title>
</head>

<body class="bod">
<center>
    <form action="logincheck.jsp" method="post">
        <table align="center"  class="cell">
        <tr>
		<th>用户名：</th>
                <th><input class="sub" name="username" type="text"></th>
        </tr>
	<tr>
                <th>密码：</th>
                <th><input class="sub" name="password" type="password"></th>
	</tr>
	<tr>
                <th colspan="2">
                    <input class="sub2" type="submit" name="submit" value="登录">
                    <!--<input type="button" value="注册">-->
                    <input class="sub2" type="reset" value="重置">
                </th>
	</tr>
        </table>
    </form>
</center>
</body>
</html>
