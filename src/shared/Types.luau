--!strict

export type Service = {
	Name: string,
	Init: (() -> ())?,
	Start: (() -> ())?,
}

export type Controller = {
	Name: string,
	Init: (() -> ())?,
	Start: (() -> ())?,
}

export type RemoteKind = "Event" | "Function"

return {}
