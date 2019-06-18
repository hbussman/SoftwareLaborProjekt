var _context = "";

function api_set_context(context) {
    _context = context;
    console.log("[API] set context: '" + _context + "'");
}

function _path(what) {
    return _context + '/api/' + what;
}

function _xwwwfurlenc(srcjson){
    if(typeof srcjson !== "object") {
        if (typeof console !== "undefined") {
            console.error("_xwwwfurlenc expects JSON object, got " + typeof(srcjson));
            return null;
        }
    }
    var url_params = "";
    var keys = Object.keys(srcjson);
    for(var i=0; i < keys.length; i++){
        url_params += encodeURIComponent(keys[i]) + "=" + encodeURIComponent(srcjson[keys[i]]);
        if(i < (keys.length-1))
            url_params += "&";
    }
    return "?" + url_params;
}

function _get(what, args) {
    return fetch(_path(what) + _xwwwfurlenc(args), {
        method: "GET", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
        },
        redirect: "follow", // manual, *follow, error
        referrer: "no-referrer" // no-referrer, *client
        //body: JSON.stringify(args) // body data type must match "Content-Type" header
    });
}

function _post(what, args) {
    console.log("_post " + JSON.stringify(args));
    return fetch(_path(what), {
        method: "POST", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/json;charset=UTF-8"
        },
        redirect: "follow", // manual, *follow, error
        referrer: "no-referrer", // no-referrer, *client
        body: JSON.stringify(args) // body data type must match "Content-Type" header
    });
}

function _put(what, args) {
    console.log("_put " + JSON.stringify(args));
    return fetch(_path(what), {
        method: "PUT", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/json;charset=UTF-8"
        },
        redirect: "follow", // manual, *follow, error
        referrer: "no-referrer", // no-referrer, *client
        body: JSON.stringify(args) // body data type must match "Content-Type" header
    });
}

function _patch(what, args) {
    console.log("_patch " + JSON.stringify(args));
    return fetch(_path(what), {
        method: "PATCH", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/json;charset=UTF-8"
        },
        redirect: "follow", // manual, *follow, error
        referrer: "no-referrer", // no-referrer, *client
        body: JSON.stringify(args) // body data type must match "Content-Type" header
    });
}

function _delete(what, args) {
    console.log("_delete " + JSON.stringify(args));
    return fetch(_path(what), {
        method: "DELETE", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, cors, *same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "same-origin", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/json;charset=UTF-8"
        },
        redirect: "follow", // manual, *follow, error
        referrer: "no-referrer", // no-referrer, *client
        body: JSON.stringify(args) // body data type must match "Content-Type" header
    });
}

function _give_json(result) {
    return result.json();
}

function _give_text(result) {
    return result.text();
}


/**
 * @param json_info must contain all the fields of SponsorEntitiy
 * @returns {Promise<Response>}
 */
function db_save_sponsor_info(json_info) {
    return _patch("sponsor", json_info);
}

function db_send_new_veranstaltung(name, ort, start_date, start_time, ende_date, ende_time, beschreibung, event_type) {
    return _post("event", {
        name: name,
        ort: ort,
        start: start_date + "T" + start_time,
        ende: ende_date + "T" + ende_time,
        beschreibung: beschreibung,
        discriminator: event_type
    });
}

function db_save_event_data(eventId, name, ort, start_date, start_time, ende_date, ende_time, beschreibung, event_type) {
    return _patch("event/" + eventId, {
        name: name,
        ort: ort,
        start: start_date + "T" + start_time,
        ende: ende_date + "T" + ende_time,
        beschreibung: beschreibung,
        discriminator: event_type
    });
}

function db_event_add_organisers(eventId, sponsors) {
    return _put("event/" + eventId, {
        sponsors: sponsors
    });
}

function db_delete_veranstaltung(eventId) {
    return _delete("event/" + eventId, {});
}

function db_save_account(newUsername, newPassword) {
    return _patch("account", {
        username: newUsername,
        password: newPassword
    });
}
