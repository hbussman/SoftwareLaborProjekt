<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="event" type="sponsoren.orm.VeranstaltungEntity"--%>
<%--@elvariable id="eventSponsors" type="java.util.List<sponsoren.orm.SponsorEntity>"--%>
<%--@elvariable id="locations" type="java.util.Map<Integer, sponsoren.orm.LocationEntity>"--%>
<c:set var="context" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
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
    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>

    <title>Event-site</title>
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

        .bg-image {
            background-image: url(https://i.imgur.com/zh6A23R.jpg);
            height: 100%;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }
    </style>
</head>

<body>
<nav class="navbar fixed-top navbar-dark bg-dark" style="min-height: 50px">
    <p class="navbar-text navbar-center text-white" style="font-size: x-large">${event.name}</p>
</nav>
<nav class="navbar fixed-bottom navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="btn-group" role="group" aria-label="Basic example" style="min-width: 100%">
        <a id="Attractionbutton" class="btn btn-primary btn-light " aria-disabled="false" href="${context}/attractions"
           role="button"><i class="fas fa-landmark"></i></a>
        <a id="Homebutton" class="btn btn-primary btn-light" aria-disabled="false" href="${context}/sponsoren"
           style="background: aquamarine"><i class="fas fa-home"></i></a>
        <a id="Eventbutton" class="btn btn-primary btn-light " href="${context}/events" role="button"
           aria-disabled="false"><i class="far fa-calendar-alt"></i>
        </a>
    </div>
</nav>

<div class="container-fluid bg-image pt-5">

    <div class="card pb-5 justify-content-center">
        <span class="d-block p-1 bg-light text-dark text-center"></span>
        <div class="container">
            <div class="card-text text-dark">
                ${event.beschreibung}
            </div>
            <div class="card-body text-dark"><i class="fas fa-thumbtack"></i>
                ${locations.get(event.locationID).name}
                <div class="card-text text-dark"><i
                        class="far fa-calendar-alt"></i> ${util.prettifyTimestamp(event.start)}
                    - ${util.prettifyTimestamp(event.ende)}</div>
            </div>
            <span class="d-block p-1 bg-light text-dark text-center"><b>Gesponsort von</b></span>
            <div class="row no-gutters justify-content-xs-center">

                <c:forEach items="${eventSponsors}" var="sponsor">
                
                    <div class="card shadow p-3 mb-5 bg-white rounded">
                    <a id="${event.id}" href="${context}/sponsor?name=${sponsor.name}">
                        <img src="${imagesBase}/${sponsor.name}_scaled.png" class="card-img-top"
                             alt="${sponsor.name}-Logo">
                    </a>
                    </div>
                
                </c:forEach>
            </div>
        </div>
        

    </div>
</div>
</div>

</body>
</html>
