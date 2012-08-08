
// This class dispatches an http request to the specified http server
// using AJAX. The recipient is responsible for handling the returned
// response via the delegate assigned to this class.




// Constructor.

// <param name="delegate">Delegate to handle the response.</param>
function HttpRequest (delegate)
{
	
	// Stores the HTTP request object.
	
	this.mHttp = null;
	
	
	
	// Delegate to callback when the HTTP response has been received.
	
	// <param name="sender">Reference to the HttpRequest object.</param>
	// <param name="response">HttpResponse object.</param>
	this.mDelegate = delegate;


	
	// Stores the Url of the request made.
	
	this.Url = null;
}



// Supported HTTP request methods.

HttpRequest.Method =
{
	GET : "GET",
	POST : "POST",
	HEAD : "HEAD",
	PUT : "PUT",
	DELETE : "DELETE",
	OPTIONS : "OPTIONS",
	TRACE : "TRACE",
	CONNECT : "CONNECT"
}



// Function called several times throughout the life of an HTTP request.

HttpRequest.prototype.OnHttpState = function ()
{
	// 0 = Unsent
	// 1 = Opened
	// 2 = Headers received
	// 3 = Loading
	// 4 = Done
	if ( (this.readyState == 4) && (this.Delegate != null) )
	{
		// Create response object
		var response = new HttpResponse();
		response.StatusCode = this.status;
		response.ResponseText = this.responseText;
		response.State = this.State;
	
		// Notify
		if (this.Delegate != null)
			this.Delegate(this, response);
	}
}




// Submit a request to the server.

// <param name="type">GET or POST.</param>
// <param name="url">Location of the request.</param>
// <param name="data">Optional data for a POST request. Set to null if not used.</param>
// <param name="state">Optional state object to include with the request.</param>
// <param name="binary">True if the request handles binary data.</param>
HttpRequest.prototype.SendRequest = function (type, url, data, state, binary)
{
	// Cancel any current connection.
	this.Cancel();

	// Setup new request
	this.Url = url;
	this.mHttp = HttpRequest.CreateRequest();
	if ( this.mHttp != null )
	{
		if ( binary && this.mHttp.overrideMimeType )
			this.mHttp.overrideMimeType('text/plain; charset=x-user-defined');
	
		// Dispatch Request
		this.mHttp.Delegate = this.mDelegate;
		this.mHttp.State = state;
		this.mHttp.onreadystatechange = this.OnHttpState;
		this.mHttp.open(type, url, true);
		this.mHttp.send(data);
	}
}



// Cancel a current request.

HttpRequest.prototype.Cancel = function ()
{
	if ( this.mHttp != null )
	{
		this.mHttp.abort();
		this.mHttp = null;
	}
}



// Creates a request object. Different browsers have different HTTPRequest objects.

HttpRequest.CreateRequest = function ()
{
	try
	{
		// Firefox, Opera 8.0+, Safari
		return new XMLHttpRequest();
	}
	catch (e)
	{
		// Internet Explorer
		try
		{
			return new ActiveXObject("Msxml2.XMLHTTP");
		}
		catch (e)
		{
			try
			{
				return new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch (e)
			{
				// Unknown
				return null;
			}
		}
	}
	return null;
}