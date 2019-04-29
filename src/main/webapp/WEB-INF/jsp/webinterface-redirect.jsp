<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE HTML>
<html>
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet"
          href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
          crossorigin="anonymous">

    <!-- own scripts -->
    <script src="/js/api_client.js"></script>
    <script src="/js/util.js"></script>

    <title>Weiterleitung...</title>
</head>
<body>

<!-- Redirect to home if we are logged in or to login page otherwise -->
<script>
    var username = getCookie("username");
    if(username == null) {
        document.location = "/webinterface/login";
    } else {
        document.location = "/webinterface/home?sponsor=" + username;
    }
</script>
</body>
