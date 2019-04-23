<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%--@elvariable id="locations" type="java.util.Map<Integer, sponsoren.orm.LocationEntity>"--%>

<!DOCTYPE html>
<html lang="en">
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

    <title>Sponsor-Eventlist</title>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="/sponsoren">Home</a>
    <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
        <li class="nav-item active ml-1">

        </li>
    </ul>
</nav>
<table class="table table-bordered table-striped">
    <thead>
    <tr>
        <th style="width: 150px;">Veranstaltung</th>
        <th style="width: 150px;">Ort?</th>
        <th style="width: 150px;">Datum</th>
    </tr>
    </thead>
    <tbody>
    <%--@elvariable id="events" type="java.lang.List<sponsoren.orm.VeranstaltungEntity>"--%>
    <c:forEach items="${events}" var="event">
        <tr>
            <td>${event.name}</td>
            <td>${locations.get(event.locationID).name}</td>
            <td>${event.start} bis ${event.ende}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>
