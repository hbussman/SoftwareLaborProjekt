<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="context" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
          integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

    <script src="${context}/js/util.js"></script>
    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>

    <title>Login für Sponsoren</title>

    <script>
        function DoLogin() {
            var username = document.getElementById("username").value;
            var password = document.getElementById("password").value;

            // TODO: send actual login request to backend

            // pretend we logged in
            setCookie("username", username, 180, "webinterface");

            // redirect to dashboard
            window.location.href = "${context}/webinterface/home?sponsor=" + username;
        }

        function Init() {
            // logout
            deleteCookie("username", "webinterface");
        }
    </script>
    <style>
        .navbar-center {
            position: absolute;
            width: 100%;
            left: 0;
            top: 0;
            text-align: center;
        }
    </style>

</head>
<body onload="Init()">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <ul class="nav navbar-nav ml-auto">
    </ul>
    <p class="navbar-text navbar-center text-white" style="font-size: x-large">Sponsoren Login</p>
    <a id="logoutbutton" class="btn btn-danger disabled" href="${context}/webinterface/login" role="button"><i
            class="fa fa-sign-out-alt" aria-disabled="true"></i>
    </a>
</nav>
<div class="container mt-5">
    <div class="row">
        <div class="offset-md-2 col-md-8 offset-lg-4 col-lg-4">
            <div class="card text-center">
                <div class="card-header">
                    Sponsoren Webinterface
                </div>
                <div class="card-body">
                    <h5 class="card-title">Login</h5>

                    <form name="f" action="${context}/webinterface/login" method="POST">
                        <div class="input-group flex-nowrap">
                            <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-user"></i>
                                </span>

                            </div>
                            <input name="username" id="username" type="text" class="form-control" placeholder="Username"
                                   aria-label="Username"
                                   aria-describedby="addon-wrapping">
                        </div>
                        <div class="input-group flex-nowrap">
                            <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-unlock-alt"></i>
                                </span>
                            </div>
                            <input name="password" id="password" type="password" class="form-control"
                                   placeholder="Password" aria-label="Password"
                                   aria-describedby="addon-wrapping">
                        </div>
                        <p class="card-text"></p>
                        <input type="submit" class="btn btn-dark" value="Anmelden">
                        <input type="hidden"
                               name="${_csrf.parameterName}"
                               value="${_csrf.token}"/>
                    </form>
                </div>
                <c:if test="${param.error != null}">
                    <p style="color:red;">
                        Falscher Username oder Passwort!
                    </p>
                </c:if>
            </div>
        </div>
    </div>

</div>

</body>
</html>
