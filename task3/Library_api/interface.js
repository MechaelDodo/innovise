


/*-----------------------------------------------------------------------*/
/*Book*/

function showBooks(){
    $.ajax("http://localhost:3000/books",{
            success: function (data){
                d = '';
                data.forEach(entry=>{
                    athr = JSON.stringify(entry.author)
                    pblshr = JSON.stringify(entry.publisher)
                    ctgrs = JSON.stringify(entry.categories)
                    d += "ID - "+entry.id+"; Name - "+entry.name+"; Author - "+athr+"; Publisher - "
                        +pblshr+"; Categories - "+ctgrs+"\n\n\n";
                })
                alert(d)
            }
        }
    );
}
function showBook(){
    let book_id = document.getElementById('inputBookID').value;
    $.ajax("http://localhost:3000/books/"+book_id,{
            success: function (data){
                athr = JSON.stringify(data.author)
                pblshr = JSON.stringify(data.publisher)
                ctgrs = JSON.stringify(data.categories)
                d = "ID - "+data.id+"; Name - "+data.name+"; Author - "+athr+"; Publisher - "
                    +pblshr+"; Categories - "+ctgrs+"\n\n\n";
                alert(d)
            }
        }
    );
}


function addBook()
{
    let book_name = document.getElementById('inputBookName').value;
    let book_price = document.getElementById('inputBookPrice').value;
    let author_id = document.getElementById('inputAuthorID_forBook').value;
    let publisher_id = document.getElementById('inputPublisherID_forBook').value;

    $.ajax({
        url: 'http://localhost:3000/books',
        method: 'post',
        dataType: 'json',
        data: {
            "book":{
                "name": book_name,
                "price": book_price,
                "author_id": author_id,
                "publisher_id": publisher_id
            }
        }
    })
}

function updateBook()
{
    let book_id = document.getElementById('inputBookID').value;
    let book_name = document.getElementById('inputBookName').value;
    let author_id = document.getElementById('inputAuthorID_forBook').value;
    let publisher_id = document.getElementById('inputPublisherID_forBook').value;

    $.ajax({
        url: 'http://localhost:3000/books/'+book_id,
        method: 'put',
        dataType: 'json',
        data: {
            "book":{
                "name": book_name,
                "price": book_price,
                "author_id": author_id,
                "publisher_id": publisher_id
            }
        }
    })
}

function deleteBook()
{
    let book_id = document.getElementById('inputBookID').value;

    $.ajax({
        url: 'http://localhost:3000/books/'+book_id,
        method: 'delete',
        dataType: 'json',
    })
}
/*-----------------------------------------------------------------------*/
/*Author*/

function showAuthors(){
    $.ajax("http://localhost:3000/authors",{
            success: function (data){
                d = '';
                data.forEach(entry=>{
                    d += "ID - "+entry.id+"; Name - "+entry.name+";\n\n\n";
                })
                alert(d)
            }
        }
    );
}
function showAuthor(){
    let author_id = document.getElementById('inputAuthorID').value;
    $.ajax("http://localhost:3000/authors/"+author_id,{
            success: function (data){
                d = "ID - "+data.id+"; Name - "+data.name+";\n\n\n";
                alert(d)
            }
        }
    );
}

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

function updateAuthor()
{
    let author_id = document.getElementById('inputAuthorID').value;
    let author_name = document.getElementById('inputAuthorName').value;

    $.ajax({
        url: 'http://localhost:3000/authors/'+author_id,
        method: 'put',
        dataType: 'json',
        data: {
            "author":{"name": author_name}
        }
    })
}

function deleteAuthor()
{
    let author_id = document.getElementById('inputAuthorID').value;

    $.ajax({
        url: 'http://localhost:3000/authors/'+author_id,
        method: 'delete',
        dataType: 'json',
    })
}
/*-----------------------------------------------------------------------*/
/*Publisher*/
function showPublishers(){
    $.ajax("http://localhost:3000/publishers",{
            success: function (data){
                d = '';
                data.forEach(entry=>{
                    d += "ID - "+entry.id+"; Name - "+entry.name+";\n\n\n";
                })
                alert(d)
            }
        }
    );
}
function showPublisher(){
    let publisher_id = document.getElementById('inputPublisherID').value;
    $.ajax("http://localhost:3000/publishers/"+publisher_id,{
            success: function (data){
                d = "ID - "+data.id+"; Name - "+data.name+";\n\n\n";
                alert(d)
            }
        }
    );
}

function addPublisher()
{
    let publisher_name = document.getElementById('inputPublisherName').value;

    $.ajax({
        url: 'http://localhost:3000/publishers',
        method: 'post',
        dataType: 'json',
        data: {
            "publisher":{"name": publisher_name}
        }
    })
}

function updatePublisher()
{
    let publisher_id = document.getElementById('inputPublisherID').value;
    let publisher_name = document.getElementById('inputPublisherName').value;

    $.ajax({
        url: 'http://localhost:3000/publishers/'+publisher_id,
        method: 'put',
        dataType: 'json',
        data: {
            "publisher":{"name": publisher_name}
        }
    })
}

function deletePublisher()
{
    let publisher_id = document.getElementById('inputPublisherID').value;

    $.ajax({
        url: 'http://localhost:3000/publishers/'+publisher_id,
        method: 'delete',
        dataType: 'json',
    })
}

/*-----------------------------------------------------------------------*/
/*Category*/

function showCategories(){
    $.ajax("http://localhost:3000/categories",{
            success: function (data){
                d = '';
                data.forEach(entry=>{
                    d += "ID - "+entry.id+"; Name - "+entry.name+";\n\n\n";
                })
                alert(d)
            }
        }
    );
}
function showCategory(){
    let category_id = document.getElementById('inputCategoryID').value;
    $.ajax("http://localhost:3000/categories/"+category_id,{
            success: function (data){
                d = "ID - "+data.id+"; Name - "+data.name+";\n\n\n";
                alert(d)
            }
        }
    );
}

function addCategory()
{
    let category_name = document.getElementById('inputCategoryName').value;

    $.ajax({
        url: 'http://localhost:3000/categories',
        method: 'post',
        dataType: 'json',
        data: {
            "category":{"name": category_name}
        }
    })
}

function updateCategory()
{
    let category_id = document.getElementById('inputCategoryID').value;
    let category_name = document.getElementById('inputCategoryName').value;

    $.ajax({
        url: 'http://localhost:3000/categories/'+category_id,
        method: 'put',
        dataType: 'json',
        data: {
            "category":{"name": category_name}
        }
    })
}

function deleteCategory()
{
    let category_id = document.getElementById('inputCategoryID').value;

    $.ajax({
        url: 'http://localhost:3000/categories/'+category_id,
        method: 'delete',
        dataType: 'json',
    })
}

/*-----------------------------------------------------------------------*/