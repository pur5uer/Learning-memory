<%@ page contentType="text/html; charset=utf-8" errorPage="" %>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<html>
    <meta http-equiv="refresh" content="10">
    <body>
        <div class = "d1_1">
        <form action="message.jsp" method="post">
            <input class="sub0" type="submit" name="clean" value="清空列表">
        </form>
        </div>
<%
//    Date reDate = new Date(System.currentTimeMillis());
//    String ft = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(reDate);
    response.setIntHeader("Refresh", 5);
%>
    <div  class = "d1" style="">
        <form action="solvelist/add_in.jsp" method="post"></form>
    </div>
    <jsp:useBean id="time" class="java.util.Date"/>
    <p>	现在时间：<%=time%> </p>
<%
    request.setCharacterEncoding("utf-8");
    String temp = time.toString();
    String str = ""; String s = "";
    String fevername = ( String ) request.getSession().getAttribute("fevername");
    String feverid = ( String ) request.getSession().getAttribute("feverid");
    String fevermachine = ( String ) request.getSession().getAttribute("fevermachine");
    String feversituation = ( String ) request.getSession().getAttribute("feversituation");
    String clean = request.getParameter("clean");
//    out.print(fevername+"<br/>"+feverid+"<br/>"+fevermachine+"<br/>"+feversituation+"<br/>");
    try {
        //********************************先改数据库的连接***************************************
        //数据库的连接
        Class.forName("com.mysql.cj.jdbc.Driver");  ////驱动程序名
        String url = "jdbc:mysql://localhost:3306/lab"+ "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"; //数据库名
        String username = "root";  //数据库用户名
        String password = "123123";  //数据库用户密码
        Connection conn = DriverManager.getConnection(url, username, password);  //连接状态

        if(conn != null){
            out.print("数据库连接成功！" + "<br />");
            Statement stmt = null;                   //查询语句
            ResultSet rs = null;
            String sql = "SELECT * FROM message;";          //按id查询
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
            if(clean != null) {
                str = "DELETE FROM message;";
                int tmp = stmt.executeUpdate(str);
                if(tmp == 0) out.print("清空失败！"+ "<br/>");
            }
            if(feversituation != null) {
                //********************处理新的数据************************
                if(feversituation.equals("#FF0000")) {
                    str = temp+","+ fevermachine + "号座位的" + fevername + "(" + feverid + ")由不发热转为发热状态，并尝试进入实验室";
                } else if(feversituation.equals("#CD2626")) {
                    str = temp+","+ fevermachine + "号座位的" + fevername + "(" + feverid + ")在发热状态尝试进入实验室";
                } else if(feversituation.equals("#0F0F0F")){
                    str = temp+","+ fevermachine + "号座位的" + fevername + "(" + feverid + ")在实验室里出现发热症状，并尝试离开实验室";
                } else if(feversituation.equals("#9BCD9B")) {
                    str = temp+","+ fevermachine + "号座位的" + fevername + "(" + feverid + ")不再发热，并进入实验室";
                } else if(feversituation.equals("#7B68EE")) {
                    str = temp+","+ fevermachine + "号座位的" + fevername + "(" + feverid + ")在实验室内不再发热，并离开实验室";
                } else if(feversituation.equals("#737373")) {
                    str = temp+","+ fevermachine + "号座位的" + fevername + "(" + feverid + ")为发热状态，并尝试离开实验室";
                }
                s = "INSERT INTO message (Text,Color) VALUES (\"" + str + "\",\"" + feversituation + "\");";
        //        out.print(s+"<br/>");
                int r = stmt.executeUpdate(s);
                session.removeAttribute("feversituation");
                session.removeAttribute("fevername");
                session.removeAttribute("feverid");
                session.removeAttribute("fevermachine");
            }
            rs = stmt.executeQuery(sql);
            rs.last();
            if(rs.getRow() > 100) {
                int r = stmt.executeUpdate("delete from message where 1=1 limit 3;");
            }
            rs = stmt.executeQuery(sql);
            while(rs.next()) {
                out.print("<p " + "style = \"color: " + rs.getString("Color") +"\">"+ rs.getString("Text")+"</p>");
            }
            conn.close();
        } else {
            out.print("数据库连接失败！");
        }
    } catch(Exception e) {
        out.print("数据库连接异常！");
    }
%>
    </body>
</html>
