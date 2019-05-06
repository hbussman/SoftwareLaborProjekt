<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="context" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

    <script src="${context}/js/util.js"></script>
    <script src="${context}/js/api_client.js"></script>

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

</head>
<body onload="Init()">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" style="color: whitesmoke">Sponsoren-Login</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTogglerDemo02"
            aria-controls="navbarTogglerDemo02" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
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

                    <form action="javascript:DoLogin();">
                        <div class="input-group flex-nowrap">
                            <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-user"></i>
                                </span>

                            </div>
                            <input id="username" type="text" class="form-control" placeholder="Username" aria-label="Username"
                                   aria-describedby="addon-wrapping">
                        </div>
                        <div class="input-group flex-nowrap">
                            <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-unlock-alt"></i>
                                </span>
                            </div>
                            <input id="password" type="password" class="form-control" placeholder="Password" aria-label="Password"
                                   aria-describedby="addon-wrapping">
                        </div>
                        <p class="card-text"></p>
                        <input type="submit" class="btn btn-dark" onclick="DoLogin()" value="Anmelden">
                    </form>

                </div>
            </div>
        </div>
    </div>

</div>

</body>
</html>
