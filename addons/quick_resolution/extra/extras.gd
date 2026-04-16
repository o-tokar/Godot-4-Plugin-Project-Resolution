class_name Extras extends RefCounted

static func connect_once(s: Signal, fn: Callable):
	if not s.is_connected(fn):
		s.connect(fn)

static func disconnect_once(s: Signal, fn: Callable):
	if s.is_connected(fn):
		s.disconnect(fn)

static func disconnect_all(s: Signal):
	var connections = s.get_connections()
	for i in range(connections.size()):
		connections[i].signal.disconnect(connections[i].callable)
		# print(c.callable.hash())


static func serialize_resource(resource: Resource, path: String) -> bool:
	var error = ResourceSaver.save(resource, path)
	if error == OK:
		# print("Resource file serialized successfully. \n {path}".format({"path": path}))
		return true
	else:
		printerr("Failed to serialize resource file. \n {path}".format({"path": path}))
		return false
