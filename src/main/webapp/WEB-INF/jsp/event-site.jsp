<%--
  Created by IntelliJ IDEA.
  User: felix
  Date: 23.04.2019
  Time: 14:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
          integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
    <!-- own scripts -->
    <script src="/js/api_client.js"></script>

    <title>Event-site</title>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="">Home</a>
    <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
        <li class="nav-item active ml-1">
            <a class="nav-link" href="/events">
                <i class="far fa-calendar"></i>
                <span class="sr-only">(current)</span></a>
        </li>
    </ul>
</nav>
<div class="container">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="text-center">
                        <h5 class="card-title">Veranstaltungsname</h5>
                        <p class="card-text">Veranstaltungsbeschreibung</p>
                    </div>
                    <div class="text-center">
                        <div class="card-body">
                            <h5 class="card-title">Sponsorname</h5>
                            <img src="">
                            <a href="SPONSORENSEITE" class="btn btn-dark">Sponsorenseite</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
