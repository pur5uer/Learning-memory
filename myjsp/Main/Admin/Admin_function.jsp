<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<body>
<%
    String name = (String)session.getAttribute("username");
    String is_out = (String)session.getAttribute("is_out");
    if((is_out == null || is_out.equals("0")) && name == null){
        out.print("<script>alert('请先登录');</script>");
        response.setHeader("refresh","1;url = ../default/Main.jsp");
    }
%>
    </dl>
    </li></ul>
     <ul class="mList">
        <li>
        <h3><span></span>管理员功能</h3>
        <dl>
        <dd><a href="message.jsp" target ="rightframe">警报信息</a></dd>
        <dd><a href="search_Stu.jsp" target ="rightframe">查询信息</a></dd>
        <dd><a href="update_Admin.jsp" target ="rightframe">账号修改</a></dd>

        <dd><a href="../default/Main.jsp" target ="_top">退出登陆</a></dd>
     </dl>
    </li></ul>
</body>
</html>
