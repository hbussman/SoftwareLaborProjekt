<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="sponsor" type="sponsoren.orm.SponsorEntity"--%>

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

    <script src="/js/util.js"></script>
    <script src="/js/api_client.js"></script>

    <title>Persönloche Seite - Sponsoren</title>

    <script>
        function Init() {
            var username = getCookie("username");
        }
    </script>

</head>
<body onload="Init()">
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="#">Persönliche Seite</a>
        <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
            <li class="nav-item active ml-1">
                <a class="nav-link" href="/webinterface/edit">
                    <i class="far fa-edit"></i>
                    <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item active ml-1">
                <a class="nav-link" href="/webinterface/login">
                    <i class="fa fa-sign-out-alt"></i>
                    <span class="sr-only">(current)</span></a>
            </li>
        </ul>
</nav>
<div class="container mt-4">
    <div class="row">
        <div class="offset-md-2 col-md-8 offset-lg-2 col-lg-8 col-sm-12">
        <div class="card" style="width:100%">
            <div class="text-center">
            <img src="/img/${sponsor.name}_scaled.png" style="" class="card-img-top" alt="...">
            </div>
            <div class="card-body">
                <h5 class="card-title">Willkommen, ${sponsor.name}</h5>

                <p class="card-title"><u>Beschreibung</u></p>
                <p class="card-text">${sponsor.beschreibung}</p>

                <p class="card-title"><u>Werbetext</u></p>
                <p class="card-text">${sponsor.werbetext}</p>

                <p class="card-title"><u>Persönliche Daten</u></p>
                <p class="card-text">Eigene Homepage: ${sponsor.homepage}</p>
                <p class="card-text">
                    Ansprechpartner<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sponsor.ansprechpartnerVorname} ${sponsor.ansprechpartnerNachname}<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sponsor.telefonnummer}<br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sponsor.adresse}
                </p>

                <!-- <a href="#" class="btn btn-dark">Go somewhere</a> -->
            </div>

        </div>
    </div>
</div>
</div>

</body>
</html>
