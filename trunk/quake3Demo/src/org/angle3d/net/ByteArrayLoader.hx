package org.angle3d.net;

import flash.net.URLLoaderDataFormat;

class ByteArrayLoader extends DataLoader
{
	public function new()
	{
		super(URLLoaderDataFormat.BINARY);
	}
}