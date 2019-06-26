<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="attractions" type="java.util.List<sponsoren.orm.AttraktionEntity>"--%>
<%--@elvariable id="attractionsSponsors" type="java.util.Map<java.lang.String, java.util.List<sponsoren.orm.SponsorEntity>>"--%>
<%--@elvariable id="searchString" type="java.lang.String"--%>
<c:set var="context" value="${pageContext.request.contextPath}"/>

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
    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>
    <script src="${context}/js/searchbar.js"></script>

    <!-- own css -->
    <link rel="stylesheet" type="text/css" href="${context}/css/background.css" media="screen" />

    <title>Sponsoren-Attraktionenliste</title>

</head>
<body class="bg-image">
<nav class="navbar fixed-top navbar-dark bg-dark pb-0" style="min-height: 50px">
    <div class="container justify-content-center">
        <div class="navbar-header">
            <p class="navbar-brand " > Attraktionen </p>
            <button input class="btn btn-light" type="submit"  data-toggle="collapse" data-target="#navbar-responsive-65"> <i class="fas fa-search"></i>
            </button>
        </div>
        <div class="collapse" id="navbar-responsive-65">
            <div class="navbar ">
                <script>
                    function search() {
                        var content = document.getElementById("suchFeld").value;
                        window.location="${context}/attractions?search="+content;
                    }
                </script>
                <form class="search-form searchbar" role="search" id="hiddenSearchBox" action="javascript:search()" method="get">
                    <div class="input-group">
                        <input type="hidden" name="id" value="63">
                        <input id="suchFeld" type="search" name="keywords" class="form-control" placeholder="Suche...">
                        <div class="input-group-btn">
                            <input class="btn btn-light" type="submit" value="Suchen" data-toggle="searchbar" data-target="#hiddenSearchBox">
                            </input>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</nav>
<nav class="navbar fixed-bottom navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="btn-group" role="group" style="min-width: 100%">
        <a id="Attractionbutton" class="btn btn btn-light" style="background: aquamarine; border:1px solid black"
           href="${context}/attractions" role="button"><i class="fas fa-landmark"></i></a>
        <a id="Homebutton" class="btn btn-light" style="border:1px solid black" href="${context}/sponsoren"><i class="fas fa-home"></i></a>
        <a id="Eventbutton" class="btn btn-light" style="border:1px solid black" href="${context}/events" role="button"><i class="far fa-calendar-alt"></i>
        </a>
    </div>
</nav>
<div class="pt-4"></div>
<div class="container-fluid pt-5 pb-5 mt-5">
    <div class="row justify-content-center pb-5 mx-1">
    <c:forEach items="${attractions}" var="attraction">
        <c:if test="${util.searchMatch(searchString, attraction)}">

            <!-- only show attractions that are sponsored by someone (ignored ${attraction.name}) -->
            <c:if test="${attractionsSponsors.containsKey(attraction.name)}">
                    <div class="card mb-2" style=" width: 312px;">
                        <a id="attraction-${attraction.name}" href="https://seserver.se.hs-heilbronn.de:9443/buga19bugascout/#/details/${attraction.id}" target="_blank">
                            <span class="d-block p-1 bg-light border-bottom text-dark text-center"><b>${attraction.name}</b></span>
                            <div class="container">
                                <div class="card-text text-dark" style="font-size: small">
                                    ${util.truncateLongText(attraction.beschreibung, 350)}
                                </div>
                            </div>
                        </a>

                        <!-- show all sponsors -->
                        <span class="d-block p-1 bg-light border-top text-center">
                            <b>Gesponsort von
                                <a href="${context}/sponsor?name=${attractionsSponsors.get(attraction.name).get(0).name}">${attractionsSponsors.get(attraction.name).get(0).name}</a>
                                <c:forEach items="${attractionsSponsors.get(attraction.name).subList(1, attractionsSponsors.get(attraction.name).size())}" var="sponsor">
                                    , <a href="${context}/sponsor?name=${sponsor.name}">${sponsor.name}</a>
                                </c:forEach>
                            </b>
                        </span>

                    </div>
            </c:if>

        </c:if>
    </c:forEach>
    </div>
</div>

<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
</body>
</html>
