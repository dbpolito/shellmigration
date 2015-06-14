module.exports = ((dir, alias) ->
    (a1, a2) ->
        a = []
        diff = []
        i = 0
        while i < a1.length
            a[a1[i++]] = true
        i = -1
        while ++i < a2.length
            if a[a2[i]]
                delete a[a2[i]]
            else
                a[a2[i]] = true
        for k of a
            diff.push k
        diff
)()
