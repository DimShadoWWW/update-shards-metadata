module.exports = function(doc, cb) {
    if (doc._id.startsWith("_")) {
        return cb(); //doc will not be in the output
    }

    var ip = process.env.ip;
    if (ip !== undefined && ip !== null && ip !== "") {
        var docString = JSON.stringify(doc);
        docString = docString.replace(/@(?:(?:2[0-4]\d|25[0-5]|1\d{2}|[1-9]?\d)\.){3}(?:2[0-4]\d|25[0-5]|1\d{2}|[1-9]?\d)(?:\:(?:\d|[1-9]\d{1,3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}))?/g, "@" + ip);
        doc = JSON.parse(docString);
    }
    cb(null, doc);
}
