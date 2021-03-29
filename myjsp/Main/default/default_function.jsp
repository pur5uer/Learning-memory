<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<body>
    <title>实验室管理系统</title>
    <%String errorInfo = (String)request.getAttribute("loginError");         // 获取错误属性
        if(errorInfo != null) {
    %>
        <script type="text/javascript" language="javascript">
        alert("<%=errorInfo%>");                                            // 弹出错误信息
        window.location='../../login/login.jsp' ;                            // 跳转到登录界面
        </script>
    <%}%>
    <ul class="mList">
    <li>
    <h3><span></span>学生功能</h3>
    <dl>
    <dd><a href="../check_in_list.jsp" target ="rightframe">签到/填表</a></dd>
<!---注释签退
    <dd><a href="../check_out_list.jsp" target ="rightframe">签退</a></dd>
-->
    </dl>
    </li></ul>
     <ul class="mList">
        <li>
        <h3><span></span>管理员功能</h3>
        <dl>
        <dd><a href="../../login/login.jsp" target ="rightframe">登陆</a></dd>
     </dl>
    </li></ul>
</body>
</html>
