# Event Command Map

## Overview

An Event Command Map executes commands in response to events on a given Event Dispatcher.

## Basic Usage

    eventCommandMap
        .map(SignOutEvent.SIGN_OUT, SignOutEvent)
        .toCommand(SignOutCommand);
    
    eventDispatcher.dispatchEvent(new SignOutEvent(SignOutEvent.SIGN_OUT));

Note: for a less verbose and more performant command mechanism see the MessageCommandMap extension.

## Mapping 'once' commands

If you know that you only want your command to fire once, and then be automatically unmapped:

	eventCommandMap
        .map(SignOutEvent.SIGN_OUT, SignOutEvent)
        .toCommand(SignOutCommand)
		.once();

## Mapping guards and hooks

You can optionally add guards and hooks:

	eventCommandMap
        .map(SignOutEvent.SIGN_OUT, SignOutEvent)
        .toCommand(SignOutCommand)
		.withGuards(NotOnTuesdays)
		.withHooks(UpdateLog);
	
Guards and hooks can be passed as arrays or just a list of classes.	

Guards will be injected with the event that fired, and hooks can be injected with both the event and the command (these injections are then cleaned up so that events and commands are not generally available for injection).

For more information on guards and hooks check out: 

1. robotlegs.bender.framework.readme-guards
2. robotlegs.bender.framework.readme-hooks

## Note: strictly one mapping per-event-per-command

You can only make one mapping per event-command pair. You should do your complete mapping in one chain.

So - the following will issue a warning:

	eventCommandMap.map(SomeEvent.STARTED).toCommand(SomeCommand);
	eventCommandMap.map(SomeEvent.STARTED).toCommand(SomeCommand); // warning

If you intend to change a mapping you should unmap it first.

# Event Command Map Extension

## Requirements

This extension requires the following extensions:

+ CommandMapExtension
+ EventDispatcherExtension

## Extension Installation

    _context = new Context().install(
    	CommandCenterExtension,
    	EventDispatcherExtension,
	    EventCommandMapExtension);

Or, assuming that the EventDispatcher and CommandCenter extensions have already been installed:

	_context.install(EventCommandMapExtension);

## Extension Usage

An instance of IEventCommandMap is mapped into the context during extension installation. This instance can be injected into clients and used as below.

	[Inject]
	public var eventCommandMap:IEventCommandMap;

