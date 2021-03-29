<%@ page contentType="text/html; charset=utf-8" errorPage="" %>

<HTML>
  <head>
    <link rel="stylesheet" type="text/css" href="mystyle.css">
    <title>修改密码</title>
</head>
    <body class="bod">

    <%String name = (String)session.getAttribute("username");
    String is_out = (String)session.getAttribute("is_out");
    if(is_out.equals("0") && name == null){
        out.print("<script>alert('请先登录');</script>");
        response.setHeader("refresh","1;url = ../default/Main.jsp");
    }%>
        <style scoped></style>
      <center>
          <form action="update_Admin_check.jsp" method="post">
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
          <th>新密码：</th>
          <th><input class="sub" name="newPassword" type="text"></th>
        </tr>
        <tr>
            <th>确认新密码：</th>
            <th><input class="sub" name="passwordCheck" type="text""></th>
        </tr>
        <tr>
                      <th colspan="2">
                          <input class="sub2" type="submit" name="submit" value="修改">
                          <!--<input type="button" value="注册">-->
                          <input class="sub2" type="reset" value="重置">
                      </th>
        </tr>
              </table>
          </form>
      </center>
      </body>
      </html>
 
 
 