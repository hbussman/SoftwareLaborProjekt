<%--
  Created by IntelliJ IDEA.
  User: felix
  Date: 15.05.2019
  Time: 12:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
          integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">
    <title>Webinterface-Account</title>
    <style>
        .navbar-center
        {
            position: absolute;
            overflow: visible;
            height: 0;
            width: 100%;
            left: 0;
            top: 0;
            text-align: center;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="pr-2">
        <a class="btn btn-light" href="${context}/webinterface/home?sponsor=${sponsor.name}"
           role="button">Sponsorenseite
        </a>
    </div>
    <div class="pr-2">
        <a class="btn btn-light disabled" href="${context}/webinterface/home?sponsor=${sponsor.name}"
           role="button" aria-disabled="true">Account
        </a>
    </div>
    <ul class="nav navbar-nav ml-auto">
    <p class="navbar-text navbar-center text-white"style="font-size: x-large">Ihr Account</p>
</ul>
    <div class="pr-2">
        <a class="btnbtn-light" href="${context}/webinterface/events?sponsor=${sponsor.name}"
           role="button">Veranstaltungen
        </a>
    </div>
    <a class="btn btn-danger" href="${context}/webinterface/login" role="button"><i
            class="fa fa-sign-out-alt"></i>
    </a>
</nav>
<div class="container mt-2">
    <div class="row">
        <div class="offset-md-2 col-md-8 offset-lg-4 col-lg-4">
            <div class="card text-center">
                <div class="card-header text-center">
                    Accountdaten ändern
                </div>
                <div class="card-body">
                    <label>Username ändern:</label>
                    <div class="input-group flex-nowrap">
                        <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-user"></i>
                                </span>
                        </div>
                        <input id="username" type="text" class="form-control" value="PLACEHOLDER" aria-label="Username"
                               aria-describedby="addon-wrapping">
                    </div>
                    <div class="container mt-2"></div>
                    <label>Passwort ändern:</label>
                    <div class="input-group flex-nowrap">
                        <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-unlock-alt"></i>
                                </span>
                        </div>
                        <input id="passwort" type="password" class="form-control" placeholder="Neues Passwort" aria-label="Username"
                               aria-describedby="addon-wrapping">
                    </div>
                    <div class="container mt-2"></div>
                    <div class="input-group flex-nowrap">
                        <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-unlock-alt"></i>
                                </span>
                        </div>
                        <input id="passwort-repeat" type="password" class="form-control" placeholder="Passwort wiederholen" aria-label="Username"
                               aria-describedby="addon-wrapping">
                    </div>
                </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
</body>
</html>
