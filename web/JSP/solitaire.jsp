<%@ page import="java.sql.*"  %>
<%--
  Created by IntelliJ IDEA.
  User: lenovo
  Date: 2020/11/12
  Time: 19:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>成语接龙</title>
    <style>

    </style>
</head>
<body>
<%
    request.setCharacterEncoding("utf-8");
    response.setContentType("text/html;charset=utf-8");
    String idiom = request.getParameter("idiom");
    if (idiom.length()<4){
        out.print("您输入的可能不是成语，请检查后提交");
        response.setHeader("refresh","1;Idiom.jsp");
    }
    String url = "jdbc:mysql://localhost:3306/idiomsolitaire?useUnicode=true&characterEncoding=utf-8";
    String username = "root";
    String password = "123456";
    Connection conn = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");//加载JDBC驱动程序
        conn = DriverManager.getConnection(url, username, password);//链接数据库
    } catch (ClassNotFoundException e) {
        out.println("找不到驱动类");//抛出异常时，提示信息
    } catch (SQLException e) {
        out.println("链接MySQL数据库失败");//处理SQLException异常
    }
    try {
        String lastString = idiom.substring(3, 4);
        Statement stmt = conn.createStatement();//创建语句对象Statement
        String sql = "select * from idiom where name like '%" + lastString + "%'";
        ResultSet resultSet = stmt.executeQuery(sql);
        while (resultSet.next()) {
            String solitaireWord = resultSet.getString(2);
            if (solitaireWord.substring(0, 1).equals(lastString)) {
                idiom = solitaireWord;
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    if (idiom.length()>=4){
        session.setAttribute("idiom",idiom);
        out.println("成语已经提交成功，一秒后自动跳转");
        response.setHeader("refresh","1;result.jsp");
    }
%>
</body>
</html>
