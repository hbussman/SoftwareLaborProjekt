<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="event" type="sponsoren.orm.VeranstaltungEntity"--%>
<%--@elvariable id="eventSponsors" type="java.util.List<sponsoren.orm.SponsorEntity>"--%>
<%--@elvariable id="locations" type="java.util.Map<Integer, sponsoren.orm.LocationEntity>"--%>

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
    <script src="/js/api_client.js"></script>

    <title>Event-site</title>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="/sponsoren">Sponsoren</a>
    <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
        <li class="nav-item active ml-1">
            <a class="nav-link" href="/events">
                <i class="far fa-calendar"></i>
                <span class="sr-only">(current)</span></a>
        </li>
    </ul>
</nav>
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-body">
                    <div class="text-center">
                        <h5 class="card-title">${event.name}</h5>
                        <p class="card-text">${event.beschreibung}</p>
                        <p class="card-title">Wo? ${locations.get(event.locationID).name}</p>
                        <p class="card-title">von ${util.prettifyTimestamp(event.start)} bis ${util.prettifyTimestamp(event.ende)}</p>
                    </div>
            </div>
        </div>
        <p class="text-center">Veranstaltet von</p>
    </div>
  </div>
    <div class="row no-gutters justify-content-xs-center">
       
                         <c:forEach items="${eventSponsors}" var="sponsor">
                          <div class="col col-lg-4 col-md-6 col-sm-6 col-12">
                            <div class="card">
                                <div class="card-body">
                             		<img src="/img/${sponsor.name}_scaled.png" class="card-img-top" alt="${sponsor.name}-Logo">
                           			<h5 class="text-start">${sponsor.name}</h5>
                           			<a href="/sponsor?name=${sponsor.name}" class="btn btn-dark">Mehr Erfahren</a>
                 			    </div>
                            </div>
                          </div>
                        </c:forEach>
                   
               
             </div>
         
                

 </div>
</body>
</html>
