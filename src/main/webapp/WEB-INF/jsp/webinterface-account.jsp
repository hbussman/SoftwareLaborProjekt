<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>
<%--@elvariable id="currentUsername" type="java.lang.String"--%>
<c:set var="context" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
          integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>

    <title>Webinterface-Account</title>

    <style>
        .navbar-center {
            position: absolute;
            overflow: visible;
            height: 0;
            width: 100%;
            left: 0;
            top: 0;
            text-align: center;
        }
    </style>

    <script>
        function saveAccount() {
            var resultElem = document.getElementById('save-result');
            var pwElem = document.getElementById('passwort');
            var pw2Elem = document.getElementById('passwort-repeat');

            var username = document.getElementById('username').value;
            var pw1 = pwElem.value;
            var pw2 = pw2Elem.value;

            if(pw1 !== "" && pw1 !== pw2) {
                resultElem.style = "color:red;";
                resultElem.innerText = "Passwörter stimmen nicht überein!";
                return;
            }

            db_save_account(username, pw1).then(result => {
                if(result.ok) {
                    resultElem.style = "color:darkgreen;";
                    resultElem.innerText = "Informationen gespeichert!";
                    pwElem.value = "";
                    pw2Elem.value = "";
                } else {
                    result.text().then(error => {
                        resultElem.style = "color:red;";
                        resultElem.innerText = "Ein Fehler ist aufgetreten: " + error;
                    });
                }
            });
        }
    </script>
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
        <p class="navbar-text navbar-center text-white" style="font-size: x-large">Ihr Account</p>
    </ul>
    <div class="pr-2">
        <a class="btn btn-light" href="${context}/webinterface/events?sponsor=${sponsor.name}"
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

                    <!-- Username ändern -->
                    <label>Login-Username ändern:</label>
                    <div class="input-group flex-nowrap">
                        <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-user"></i>
                                </span>
                        </div>
                        <input id="username" type="text" class="form-control" value="${currentUsername}"
                               aria-label="Username"
                               aria-describedby="addon-wrapping">
                    </div>

                    <!-- Passwort ändern -->
                    <div class="container mt-2"></div>
                    <label>Passwort ändern:</label>
                    <div class="input-group flex-nowrap">
                        <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-unlock-alt"></i>
                                </span>
                        </div>
                        <input id="passwort" type="password" class="form-control" placeholder="Neues Passwort"
                               aria-label="Username"
                               aria-describedby="addon-wrapping">
                    </div>

                    <!-- Passwort wiederholen -->
                    <div class="container mt-2"></div>
                    <div class="input-group flex-nowrap">
                        <div class="input-group-prepend">
                                <span class="input-group-text">
                                    <i class="fa fa-unlock-alt"></i>
                                </span>
                        </div>
                        <input id="passwort-repeat" type="password" class="form-control"
                               placeholder="Passwort wiederholen" aria-label="Username"
                               aria-describedby="addon-wrapping">
                    </div>

                    <!-- Speichern -->
                    <div class="container mt-2"></div>
                    <div class="input-group flex-nowrap">
                        <button class="form-control" onclick="saveAccount();" role="button"
                                aria-describedby="addon-wrapping">Speichern
                        </button>
                    </div>
                    <p id="save-result"></p>

                </div>
            </div>
        </div>

    </div>
</div>

</body>
</html>
