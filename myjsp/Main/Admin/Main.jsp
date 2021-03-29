<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head basetarget="_parent">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>实验室后台管理</title>
<%
      String name = (String)session.getAttribute("username");
      if(name == null){
        session.setAttribute("is_out","1");
        out.print("<script>alert('请先登录');</script>");
        response.setHeader("refresh","1;url = ../default/Main.jsp");
    }
%>
<frameset rows="14%,84%">
  <frame src="../head.jsp">    <!--头部的jsp文件 -->
  <frameset cols="15%,75%">
    <frame src="Admin_function.jsp">       <!--左边的jsp文件 -->
    <frame src="../default.jsp" name="rightframe">   <!--右边的jsp页面-->
  </frameset>
</frameset>

<body>

</body>
</head>
</html>
