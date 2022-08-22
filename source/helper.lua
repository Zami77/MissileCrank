function inVicinityOf(vectorA, vectorB, delta)
    delta = delta or 3
    return math.abs(vectorA.dx - vectorB.dx) < delta and math.abs(vectorA.dy - vectorB.dy) < delta
end

function secondsToMs(seconds)
    return seconds * 1000
end
