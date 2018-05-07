function getTimeStamp(input) {
    var parts = input.trim().split(' ');
    var date = parts[0].split('-');
    var time = (parts[1] ? parts[1] : '00:00:00').split(':');

    // NOTE:: Month: 0 = January - 11 = December.
    var d = Date.UTC(date[0], date[1] - 1, date[2], time[0], time[1], time[2]);
    return d / 1000;
}

// '2017-12-12 12:00:00' 1513080000
module.exports = function (done) {
    var start = getTimeStamp('2018-05-01 12:00:00');
    var end = getTimeStamp('2018-06-01 12:00:00');

    console.log(start + " - " + end);
}