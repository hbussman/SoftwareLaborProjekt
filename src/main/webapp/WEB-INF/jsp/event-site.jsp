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

    <!-- own css -->
    <link rel="stylesheet" type="text/css" href="${context}/css/background.css" media="screen"/>

    <title>Event-site</title>
    <style>
    </style>
</head>

<body class="bg-image">

<nav class="navbar fixed-top navbar-dark bg-dark pb-0" style="min-height: 50px">
    <div class="container justify-content-center">
        <div class="navbar-header">
            <p class="navbar-brand "> ${event.name} </p>
        </div>
    </div>
</nav>
<nav class="navbar fixed-bottom navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="btn-group" role="group" style="min-width: 100%">
        <a id="Attractionbutton" class="btn btn-primary btn-light" style="border:1px solid black"
           href="${context}/attractions" role="button"><i
                class="fas fa-landmark"></i></a>
        <a id="Homebutton" class="btn btn-primary btn-light" style="border:1px solid black" href="${context}/sponsoren"
        ><i class="fas fa-home"></i></a>
        <a id="Eventbutton" class="btn btn-primary btn-light" href="${context}/events" role="button"
           style="background: aquamarine; border:1px solid black"
        ><i class="far fa-calendar-alt"></i>
        </a>
    </div>
</nav>
<div class="container-fluid mt-5 pt-5 pb-5 mb-5">
    <div class="card" style="width: 18rem;">
        <div class="card-body text-dark">
            <p class="card-text"> ${event.beschreibung}</p>
            <p class="card-text text-left"><span><i
                    class="fas fa-thumbtack"></i></span>${locations.get(event.locationID).name}
            </p>
            <p class="card-text text-left d-flex"><span><i
                    class="far fa-calendar-alt"></i></span>${util.prettifyTimestamp(event.start)}-
                <br>${util.prettifyTimestamp(event.ende)}</p>
            <p class="card-text">
                <a href="${context}/companyparty-map?id=${event.id}"
                   class="btn btn-secondary btn-md active"
                   role="button"
                   aria-pressed="true">Auf Karte anzeigen
                </a>
            </p>
            <p class="card-text">
                <b>Gesponsort von</b>
            </p>
            <div class="row no-gutters justify-content-center">
                <c:forEach items="${eventSponsors}" var="sponsor">
                    <div class="card shadow my-3 bg-white rounded">
                        <a id="${event.id}" href="${context}/sponsor?name=${sponsor.name}">
                            <img src="${context}/image/${sponsor.name}_scaled.png" class="card-img-top"
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
