

function addAuthor()
{
    let author_name = document.getElementById('inputAuthorName').value;

    $.ajax({
        url: 'http://localhost:3000/authors',
        method: 'post',
        dataType: 'json',
        data: {
            "author":{"name": author_name}
        }
    })
}
