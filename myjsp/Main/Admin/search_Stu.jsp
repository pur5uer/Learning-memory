<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<HTML>
<style>
    table {
        width: 800px;
    }
    tr {
        height: 70px;
    }
    .d1 {
        float: right;
        padding-top: 15px;
        margin-top: 10px;
        margin-right: 200px;
        width:500px;height:40px;
    }
    .d1_1{
        float: right;
    }
    .d1_2{
        margin-left: 160px;
    }
    .d2 {
        position: absolute;
        padding-top: 15px;
        margin-top: 150px;
        margin-left: 300px;
        width:450px;height:230px;
    }
    .d2_1{
        position: absolute;
        padding-top: 15px;
        margin-top: 10px;
        margin-left: 400px;
        width:300px;height:40px;
    }
</style>
    <h1 align="center" fontsize = "10">查询信息</h1>
<body>
<%!
    void show_message(ResultSet r,JspWriter out) throws java.io.IOException{

        out.print("<table border=\"1\">"+
                    "<tr>"+
                    "<th>学号</th>"+
                    "<th>姓名</th>"+
                    "<th>座位号</th>"+
                    "<th>在线状态</th>"+
                    "<th>发热与否</th>"+
                    "</tr>");
        try{
            r.beforeFirst();
            while(r.next()) {
                out.print("<tr>"+
                            "<td>"+r.getString("StudentId")+"</td>"+
                            "<td>"+r.getString("Name")+"</td>"+
                            "<td>"+r.getString("MachineId")+"</td>"+
                            "<td>"+r.getString("MachineStatus")+"</td>"+
                            "<td>"+r.getString("FeverStatus")+"</td>"+
                            "</tr>");
            }
        } catch(Exception e) {
            out.print("无法正常显示！");
        }
        out.print("</table>"+"<br/>");
        return;
    }
%>
<!--    ********************查询代码块******************  -->
<div class = "d1">
    <div class = "d1_1">
    <form action="insert_stu.jsp" method="post">
        <input class="sub0" type="submit" name="ins" value="添加学生">
    </form>
    </div>
    <div class="d1_2">
    <form action="search_Stu.jsp" method="post">
        <input class="sub1" name="id" type="text" placeholder="学号">
        <input class="sub2" type="submit" name="submit" value="查询">
        <input class="sub3" type="submit" name="ok" value="完成">
    </form>
    </div>
</div>
<div  class = "d2">
<%
    try {
        //********************************获取数据***************************************
        request.setCharacterEncoding("utf-8");
        String id = request.getParameter("id");
        String ok = request.getParameter("ok");
        String del = request.getParameter("del");
        String studentid = request.getParameter("studentid");
        String studentname = request.getParameter("studentname");
        String machineid = request.getParameter("machineid");
        String machinestatus = request.getParameter("machinestatus");
        String feverstatus = request.getParameter("feverstatus");
        String cha = request.getParameter("sub");
        String add = request.getParameter("subm");

        //*****************************连接数据库**********************************
        Class.forName("com.mysql.cj.jdbc.Driver");  ////驱动程序名
        String url = "jdbc:mysql://localhost:3306/lab"+ "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true"; //数据库名
        String username = "root";  //数据库用户名
        String password = "123123";  //数据库用户密码
        Connection conn = DriverManager.getConnection(url, username, password);  //连接状态

        if(conn != null){
            out.print("数据库连接成功！" + "<br />");
            Statement stmt = null;                   //查询语句
            ResultSet rs = null;
            String sql = "SELECT * FROM students";
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);

            //*********************添加信息代码*********************
            if(add != null) {
                String str = "SELECT * FROM students WHERE MachineId = \"" + machineid + "\";";
                rs = stmt.executeQuery(str);
                rs.last();
                if(rs.getRow() == 0) {
                    out.print("此座位可以添加学生"+"<br/>");
                    str = "INSERT INTO students (StudentId,Name,MachineId,MachineStatus,FeverStatus) VALUES ("+studentid+",\""+studentname+"\","+machineid+","+machinestatus+","+feverstatus+");";
                    int r = stmt.executeUpdate(str);
                    if(r == 0) out.print("添加失败！"+ "<br/>");
                    else out.print("添加成功！"+ "<br/>");
                    id = studentid;
                }
                else {
                    out.print("此座位已经有人请重新编排"+"<br/>");
                }
            }
            //*********************修改信息代码*********************
            if(cha != null) {
                String str = "UPDATE students SET StudentId = \"" + studentid + "\",Name = \"" + studentname + "\",MachineStatus = \"" + machinestatus + "\",FeverStatus = \"" + feverstatus + "\" WHERE MachineId = \"" + machineid + "\";";
                int r = stmt.executeUpdate(str);
                if(r == 0) out.print("更新失败！"+ "<br/>");
                else out.print("更新成功！"+ "<br/>");
                id = studentid;
            }
            //*******************删除信息代码**********************
            if(del != null) {
                String str = "DELETE FROM students WHERE MachineId = \"" + machineid + "\";";
                int r = stmt.executeUpdate(str);
                if(r == 0) out.print("删除失败！"+ "<br/>");
                else out.print("删除成功！"+ "<br/>");
                id = null;
            }
            //*********************查询信息代码********************
            rs = stmt.executeQuery(sql);
            if(id == null || id.length() == 0 || ok != null) {
                show_message(rs,out);
            } else {
                String str = "SELECT * FROM students WHERE StudentId = \"" + id + "\";";
                rs = stmt.executeQuery(str);
                rs.last();
                if(rs.getRow() == 0) {
                    out.print("查无此人或学号错误！" + "<br />");
                } else{
                    show_message(rs,out);
                    rs.last();
                }
%>
            <!--        ****************操作查询结果*****************                     -->
            <div class = "d2_1">
            <form action="change_stu.jsp?studentid=<%=rs.getString("StudentId")%>&studentname=<%=rs.getString("Name")%>&machineid=<%=rs.getString("MachineId")%>" method="post">
                <input class="sub4" type="submit" name="change" value="修改此人信息">
            </form>
            <form action="search_Stu.jsp?machineid=<%=rs.getString("MachineId")%>" method="post">
                <input class="sub4" type="submit" name="del" value="删除此人信息">
            </form>
            </div>
<%
            }
            conn.close();
        } else{
            out.print("数据库连接失败！");
        }
    }catch (Exception e) {
        out.print("数据库连接异常！");
    }
 %>
</div>
</body>
 </body></HTML>
