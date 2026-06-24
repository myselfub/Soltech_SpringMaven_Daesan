/*!
 * TOAST UI Select Box
 * @version 1.0.0 | Thu Oct 24 2019
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 * @license MIT
 */
(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["SelectBox"] = factory();
	else
		root["tui"] = root["tui"] || {}, root["tui"]["SelectBox"] = factory();
})(window, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	function hotDisposeChunk(chunkId) {
/******/ 		delete installedChunks[chunkId];
/******/ 	}
/******/ 	var parentHotUpdateCallback = window["webpackHotUpdate"];
/******/ 	window["webpackHotUpdate"] = // eslint-disable-next-line no-unused-vars
/******/ 	function webpackHotUpdateCallback(chunkId, moreModules) {
/******/ 		hotAddUpdateChunk(chunkId, moreModules);
/******/ 		if (parentHotUpdateCallback) parentHotUpdateCallback(chunkId, moreModules);
/******/ 	} ;
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotDownloadUpdateChunk(chunkId) {
/******/ 		var script = document.createElement("script");
/******/ 		script.charset = "utf-8";
/******/ 		script.src = __webpack_require__.p + "" + chunkId + "." + hotCurrentHash + ".hot-update.js";
/******/ 		if (null) script.crossOrigin = null;
/******/ 		document.head.appendChild(script);
/******/ 	}
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotDownloadManifest(requestTimeout) {
/******/ 		requestTimeout = requestTimeout || 10000;
/******/ 		return new Promise(function(resolve, reject) {
/******/ 			if (typeof XMLHttpRequest === "undefined") {
/******/ 				return reject(new Error("No browser support"));
/******/ 			}
/******/ 			try {
/******/ 				var request = new XMLHttpRequest();
/******/ 				var requestPath = __webpack_require__.p + "" + hotCurrentHash + ".hot-update.json";
/******/ 				request.open("GET", requestPath, true);
/******/ 				request.timeout = requestTimeout;
/******/ 				request.send(null);
/******/ 			} catch (err) {
/******/ 				return reject(err);
/******/ 			}
/******/ 			request.onreadystatechange = function() {
/******/ 				if (request.readyState !== 4) return;
/******/ 				if (request.status === 0) {
/******/ 					// timeout
/******/ 					reject(
/******/ 						new Error("Manifest request to " + requestPath + " timed out.")
/******/ 					);
/******/ 				} else if (request.status === 404) {
/******/ 					// no update available
/******/ 					resolve();
/******/ 				} else if (request.status !== 200 && request.status !== 304) {
/******/ 					// other failure
/******/ 					reject(new Error("Manifest request to " + requestPath + " failed."));
/******/ 				} else {
/******/ 					// success
/******/ 					try {
/******/ 						var update = JSON.parse(request.responseText);
/******/ 					} catch (e) {
/******/ 						reject(e);
/******/ 						return;
/******/ 					}
/******/ 					resolve(update);
/******/ 				}
/******/ 			};
/******/ 		});
/******/ 	}
/******/
/******/ 	var hotApplyOnUpdate = true;
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	var hotCurrentHash = "fbd02ae0ea88b9f7e886";
/******/ 	var hotRequestTimeout = 10000;
/******/ 	var hotCurrentModuleData = {};
/******/ 	var hotCurrentChildModule;
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	var hotCurrentParents = [];
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	var hotCurrentParentsTemp = [];
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotCreateRequire(moduleId) {
/******/ 		var me = installedModules[moduleId];
/******/ 		if (!me) return __webpack_require__;
/******/ 		var fn = function(request) {
/******/ 			if (me.hot.active) {
/******/ 				if (installedModules[request]) {
/******/ 					if (installedModules[request].parents.indexOf(moduleId) === -1) {
/******/ 						installedModules[request].parents.push(moduleId);
/******/ 					}
/******/ 				} else {
/******/ 					hotCurrentParents = [moduleId];
/******/ 					hotCurrentChildModule = request;
/******/ 				}
/******/ 				if (me.children.indexOf(request) === -1) {
/******/ 					me.children.push(request);
/******/ 				}
/******/ 			} else {
/******/ 				console.warn(
/******/ 					"[HMR] unexpected require(" +
/******/ 						request +
/******/ 						") from disposed module " +
/******/ 						moduleId
/******/ 				);
/******/ 				hotCurrentParents = [];
/******/ 			}
/******/ 			return __webpack_require__(request);
/******/ 		};
/******/ 		var ObjectFactory = function ObjectFactory(name) {
/******/ 			return {
/******/ 				configurable: true,
/******/ 				enumerable: true,
/******/ 				get: function() {
/******/ 					return __webpack_require__[name];
/******/ 				},
/******/ 				set: function(value) {
/******/ 					__webpack_require__[name] = value;
/******/ 				}
/******/ 			};
/******/ 		};
/******/ 		for (var name in __webpack_require__) {
/******/ 			if (
/******/ 				Object.prototype.hasOwnProperty.call(__webpack_require__, name) &&
/******/ 				name !== "e" &&
/******/ 				name !== "t"
/******/ 			) {
/******/ 				Object.defineProperty(fn, name, ObjectFactory(name));
/******/ 			}
/******/ 		}
/******/ 		fn.e = function(chunkId) {
/******/ 			if (hotStatus === "ready") hotSetStatus("prepare");
/******/ 			hotChunksLoading++;
/******/ 			return __webpack_require__.e(chunkId).then(finishChunkLoading, function(err) {
/******/ 				finishChunkLoading();
/******/ 				throw err;
/******/ 			});
/******/
/******/ 			function finishChunkLoading() {
/******/ 				hotChunksLoading--;
/******/ 				if (hotStatus === "prepare") {
/******/ 					if (!hotWaitingFilesMap[chunkId]) {
/******/ 						hotEnsureUpdateChunk(chunkId);
/******/ 					}
/******/ 					if (hotChunksLoading === 0 && hotWaitingFiles === 0) {
/******/ 						hotUpdateDownloaded();
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		};
/******/ 		fn.t = function(value, mode) {
/******/ 			if (mode & 1) value = fn(value);
/******/ 			return __webpack_require__.t(value, mode & ~1);
/******/ 		};
/******/ 		return fn;
/******/ 	}
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotCreateModule(moduleId) {
/******/ 		var hot = {
/******/ 			// private stuff
/******/ 			_acceptedDependencies: {},
/******/ 			_declinedDependencies: {},
/******/ 			_selfAccepted: false,
/******/ 			_selfDeclined: false,
/******/ 			_disposeHandlers: [],
/******/ 			_main: hotCurrentChildModule !== moduleId,
/******/
/******/ 			// Module API
/******/ 			active: true,
/******/ 			accept: function(dep, callback) {
/******/ 				if (dep === undefined) hot._selfAccepted = true;
/******/ 				else if (typeof dep === "function") hot._selfAccepted = dep;
/******/ 				else if (typeof dep === "object")
/******/ 					for (var i = 0; i < dep.length; i++)
/******/ 						hot._acceptedDependencies[dep[i]] = callback || function() {};
/******/ 				else hot._acceptedDependencies[dep] = callback || function() {};
/******/ 			},
/******/ 			decline: function(dep) {
/******/ 				if (dep === undefined) hot._selfDeclined = true;
/******/ 				else if (typeof dep === "object")
/******/ 					for (var i = 0; i < dep.length; i++)
/******/ 						hot._declinedDependencies[dep[i]] = true;
/******/ 				else hot._declinedDependencies[dep] = true;
/******/ 			},
/******/ 			dispose: function(callback) {
/******/ 				hot._disposeHandlers.push(callback);
/******/ 			},
/******/ 			addDisposeHandler: function(callback) {
/******/ 				hot._disposeHandlers.push(callback);
/******/ 			},
/******/ 			removeDisposeHandler: function(callback) {
/******/ 				var idx = hot._disposeHandlers.indexOf(callback);
/******/ 				if (idx >= 0) hot._disposeHandlers.splice(idx, 1);
/******/ 			},
/******/
/******/ 			// Management API
/******/ 			check: hotCheck,
/******/ 			apply: hotApply,
/******/ 			status: function(l) {
/******/ 				if (!l) return hotStatus;
/******/ 				hotStatusHandlers.push(l);
/******/ 			},
/******/ 			addStatusHandler: function(l) {
/******/ 				hotStatusHandlers.push(l);
/******/ 			},
/******/ 			removeStatusHandler: function(l) {
/******/ 				var idx = hotStatusHandlers.indexOf(l);
/******/ 				if (idx >= 0) hotStatusHandlers.splice(idx, 1);
/******/ 			},
/******/
/******/ 			//inherit from previous dispose call
/******/ 			data: hotCurrentModuleData[moduleId]
/******/ 		};
/******/ 		hotCurrentChildModule = undefined;
/******/ 		return hot;
/******/ 	}
/******/
/******/ 	var hotStatusHandlers = [];
/******/ 	var hotStatus = "idle";
/******/
/******/ 	function hotSetStatus(newStatus) {
/******/ 		hotStatus = newStatus;
/******/ 		for (var i = 0; i < hotStatusHandlers.length; i++)
/******/ 			hotStatusHandlers[i].call(null, newStatus);
/******/ 	}
/******/
/******/ 	// while downloading
/******/ 	var hotWaitingFiles = 0;
/******/ 	var hotChunksLoading = 0;
/******/ 	var hotWaitingFilesMap = {};
/******/ 	var hotRequestedFilesMap = {};
/******/ 	var hotAvailableFilesMap = {};
/******/ 	var hotDeferred;
/******/
/******/ 	// The update info
/******/ 	var hotUpdate, hotUpdateNewHash;
/******/
/******/ 	function toModuleId(id) {
/******/ 		var isNumber = +id + "" === id;
/******/ 		return isNumber ? +id : id;
/******/ 	}
/******/
/******/ 	function hotCheck(apply) {
/******/ 		if (hotStatus !== "idle") {
/******/ 			throw new Error("check() is only allowed in idle status");
/******/ 		}
/******/ 		hotApplyOnUpdate = apply;
/******/ 		hotSetStatus("check");
/******/ 		return hotDownloadManifest(hotRequestTimeout).then(function(update) {
/******/ 			if (!update) {
/******/ 				hotSetStatus("idle");
/******/ 				return null;
/******/ 			}
/******/ 			hotRequestedFilesMap = {};
/******/ 			hotWaitingFilesMap = {};
/******/ 			hotAvailableFilesMap = update.c;
/******/ 			hotUpdateNewHash = update.h;
/******/
/******/ 			hotSetStatus("prepare");
/******/ 			var promise = new Promise(function(resolve, reject) {
/******/ 				hotDeferred = {
/******/ 					resolve: resolve,
/******/ 					reject: reject
/******/ 				};
/******/ 			});
/******/ 			hotUpdate = {};
/******/ 			var chunkId = "main";
/******/ 			// eslint-disable-next-line no-lone-blocks
/******/ 			{
/******/ 				/*globals chunkId */
/******/ 				hotEnsureUpdateChunk(chunkId);
/******/ 			}
/******/ 			if (
/******/ 				hotStatus === "prepare" &&
/******/ 				hotChunksLoading === 0 &&
/******/ 				hotWaitingFiles === 0
/******/ 			) {
/******/ 				hotUpdateDownloaded();
/******/ 			}
/******/ 			return promise;
/******/ 		});
/******/ 	}
/******/
/******/ 	// eslint-disable-next-line no-unused-vars
/******/ 	function hotAddUpdateChunk(chunkId, moreModules) {
/******/ 		if (!hotAvailableFilesMap[chunkId] || !hotRequestedFilesMap[chunkId])
/******/ 			return;
/******/ 		hotRequestedFilesMap[chunkId] = false;
/******/ 		for (var moduleId in moreModules) {
/******/ 			if (Object.prototype.hasOwnProperty.call(moreModules, moduleId)) {
/******/ 				hotUpdate[moduleId] = moreModules[moduleId];
/******/ 			}
/******/ 		}
/******/ 		if (--hotWaitingFiles === 0 && hotChunksLoading === 0) {
/******/ 			hotUpdateDownloaded();
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotEnsureUpdateChunk(chunkId) {
/******/ 		if (!hotAvailableFilesMap[chunkId]) {
/******/ 			hotWaitingFilesMap[chunkId] = true;
/******/ 		} else {
/******/ 			hotRequestedFilesMap[chunkId] = true;
/******/ 			hotWaitingFiles++;
/******/ 			hotDownloadUpdateChunk(chunkId);
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotUpdateDownloaded() {
/******/ 		hotSetStatus("ready");
/******/ 		var deferred = hotDeferred;
/******/ 		hotDeferred = null;
/******/ 		if (!deferred) return;
/******/ 		if (hotApplyOnUpdate) {
/******/ 			// Wrap deferred object in Promise to mark it as a well-handled Promise to
/******/ 			// avoid triggering uncaught exception warning in Chrome.
/******/ 			// See https://bugs.chromium.org/p/chromium/issues/detail?id=465666
/******/ 			Promise.resolve()
/******/ 				.then(function() {
/******/ 					return hotApply(hotApplyOnUpdate);
/******/ 				})
/******/ 				.then(
/******/ 					function(result) {
/******/ 						deferred.resolve(result);
/******/ 					},
/******/ 					function(err) {
/******/ 						deferred.reject(err);
/******/ 					}
/******/ 				);
/******/ 		} else {
/******/ 			var outdatedModules = [];
/******/ 			for (var id in hotUpdate) {
/******/ 				if (Object.prototype.hasOwnProperty.call(hotUpdate, id)) {
/******/ 					outdatedModules.push(toModuleId(id));
/******/ 				}
/******/ 			}
/******/ 			deferred.resolve(outdatedModules);
/******/ 		}
/******/ 	}
/******/
/******/ 	function hotApply(options) {
/******/ 		if (hotStatus !== "ready")
/******/ 			throw new Error("apply() is only allowed in ready status");
/******/ 		options = options || {};
/******/
/******/ 		var cb;
/******/ 		var i;
/******/ 		var j;
/******/ 		var module;
/******/ 		var moduleId;
/******/
/******/ 		function getAffectedStuff(updateModuleId) {
/******/ 			var outdatedModules = [updateModuleId];
/******/ 			var outdatedDependencies = {};
/******/
/******/ 			var queue = outdatedModules.map(function(id) {
/******/ 				return {
/******/ 					chain: [id],
/******/ 					id: id
/******/ 				};
/******/ 			});
/******/ 			while (queue.length > 0) {
/******/ 				var queueItem = queue.pop();
/******/ 				var moduleId = queueItem.id;
/******/ 				var chain = queueItem.chain;
/******/ 				module = installedModules[moduleId];
/******/ 				if (!module || module.hot._selfAccepted) continue;
/******/ 				if (module.hot._selfDeclined) {
/******/ 					return {
/******/ 						type: "self-declined",
/******/ 						chain: chain,
/******/ 						moduleId: moduleId
/******/ 					};
/******/ 				}
/******/ 				if (module.hot._main) {
/******/ 					return {
/******/ 						type: "unaccepted",
/******/ 						chain: chain,
/******/ 						moduleId: moduleId
/******/ 					};
/******/ 				}
/******/ 				for (var i = 0; i < module.parents.length; i++) {
/******/ 					var parentId = module.parents[i];
/******/ 					var parent = installedModules[parentId];
/******/ 					if (!parent) continue;
/******/ 					if (parent.hot._declinedDependencies[moduleId]) {
/******/ 						return {
/******/ 							type: "declined",
/******/ 							chain: chain.concat([parentId]),
/******/ 							moduleId: moduleId,
/******/ 							parentId: parentId
/******/ 						};
/******/ 					}
/******/ 					if (outdatedModules.indexOf(parentId) !== -1) continue;
/******/ 					if (parent.hot._acceptedDependencies[moduleId]) {
/******/ 						if (!outdatedDependencies[parentId])
/******/ 							outdatedDependencies[parentId] = [];
/******/ 						addAllToSet(outdatedDependencies[parentId], [moduleId]);
/******/ 						continue;
/******/ 					}
/******/ 					delete outdatedDependencies[parentId];
/******/ 					outdatedModules.push(parentId);
/******/ 					queue.push({
/******/ 						chain: chain.concat([parentId]),
/******/ 						id: parentId
/******/ 					});
/******/ 				}
/******/ 			}
/******/
/******/ 			return {
/******/ 				type: "accepted",
/******/ 				moduleId: updateModuleId,
/******/ 				outdatedModules: outdatedModules,
/******/ 				outdatedDependencies: outdatedDependencies
/******/ 			};
/******/ 		}
/******/
/******/ 		function addAllToSet(a, b) {
/******/ 			for (var i = 0; i < b.length; i++) {
/******/ 				var item = b[i];
/******/ 				if (a.indexOf(item) === -1) a.push(item);
/******/ 			}
/******/ 		}
/******/
/******/ 		// at begin all updates modules are outdated
/******/ 		// the "outdated" status can propagate to parents if they don't accept the children
/******/ 		var outdatedDependencies = {};
/******/ 		var outdatedModules = [];
/******/ 		var appliedUpdate = {};
/******/
/******/ 		var warnUnexpectedRequire = function warnUnexpectedRequire() {
/******/ 			console.warn(
/******/ 				"[HMR] unexpected require(" + result.moduleId + ") to disposed module"
/******/ 			);
/******/ 		};
/******/
/******/ 		for (var id in hotUpdate) {
/******/ 			if (Object.prototype.hasOwnProperty.call(hotUpdate, id)) {
/******/ 				moduleId = toModuleId(id);
/******/ 				/** @type {TODO} */
/******/ 				var result;
/******/ 				if (hotUpdate[id]) {
/******/ 					result = getAffectedStuff(moduleId);
/******/ 				} else {
/******/ 					result = {
/******/ 						type: "disposed",
/******/ 						moduleId: id
/******/ 					};
/******/ 				}
/******/ 				/** @type {Error|false} */
/******/ 				var abortError = false;
/******/ 				var doApply = false;
/******/ 				var doDispose = false;
/******/ 				var chainInfo = "";
/******/ 				if (result.chain) {
/******/ 					chainInfo = "\nUpdate propagation: " + result.chain.join(" -> ");
/******/ 				}
/******/ 				switch (result.type) {
/******/ 					case "self-declined":
/******/ 						if (options.onDeclined) options.onDeclined(result);
/******/ 						if (!options.ignoreDeclined)
/******/ 							abortError = new Error(
/******/ 								"Aborted because of self decline: " +
/******/ 									result.moduleId +
/******/ 									chainInfo
/******/ 							);
/******/ 						break;
/******/ 					case "declined":
/******/ 						if (options.onDeclined) options.onDeclined(result);
/******/ 						if (!options.ignoreDeclined)
/******/ 							abortError = new Error(
/******/ 								"Aborted because of declined dependency: " +
/******/ 									result.moduleId +
/******/ 									" in " +
/******/ 									result.parentId +
/******/ 									chainInfo
/******/ 							);
/******/ 						break;
/******/ 					case "unaccepted":
/******/ 						if (options.onUnaccepted) options.onUnaccepted(result);
/******/ 						if (!options.ignoreUnaccepted)
/******/ 							abortError = new Error(
/******/ 								"Aborted because " + moduleId + " is not accepted" + chainInfo
/******/ 							);
/******/ 						break;
/******/ 					case "accepted":
/******/ 						if (options.onAccepted) options.onAccepted(result);
/******/ 						doApply = true;
/******/ 						break;
/******/ 					case "disposed":
/******/ 						if (options.onDisposed) options.onDisposed(result);
/******/ 						doDispose = true;
/******/ 						break;
/******/ 					default:
/******/ 						throw new Error("Unexception type " + result.type);
/******/ 				}
/******/ 				if (abortError) {
/******/ 					hotSetStatus("abort");
/******/ 					return Promise.reject(abortError);
/******/ 				}
/******/ 				if (doApply) {
/******/ 					appliedUpdate[moduleId] = hotUpdate[moduleId];
/******/ 					addAllToSet(outdatedModules, result.outdatedModules);
/******/ 					for (moduleId in result.outdatedDependencies) {
/******/ 						if (
/******/ 							Object.prototype.hasOwnProperty.call(
/******/ 								result.outdatedDependencies,
/******/ 								moduleId
/******/ 							)
/******/ 						) {
/******/ 							if (!outdatedDependencies[moduleId])
/******/ 								outdatedDependencies[moduleId] = [];
/******/ 							addAllToSet(
/******/ 								outdatedDependencies[moduleId],
/******/ 								result.outdatedDependencies[moduleId]
/******/ 							);
/******/ 						}
/******/ 					}
/******/ 				}
/******/ 				if (doDispose) {
/******/ 					addAllToSet(outdatedModules, [result.moduleId]);
/******/ 					appliedUpdate[moduleId] = warnUnexpectedRequire;
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// Store self accepted outdated modules to require them later by the module system
/******/ 		var outdatedSelfAcceptedModules = [];
/******/ 		for (i = 0; i < outdatedModules.length; i++) {
/******/ 			moduleId = outdatedModules[i];
/******/ 			if (
/******/ 				installedModules[moduleId] &&
/******/ 				installedModules[moduleId].hot._selfAccepted &&
/******/ 				// removed self-accepted modules should not be required
/******/ 				appliedUpdate[moduleId] !== warnUnexpectedRequire
/******/ 			) {
/******/ 				outdatedSelfAcceptedModules.push({
/******/ 					module: moduleId,
/******/ 					errorHandler: installedModules[moduleId].hot._selfAccepted
/******/ 				});
/******/ 			}
/******/ 		}
/******/
/******/ 		// Now in "dispose" phase
/******/ 		hotSetStatus("dispose");
/******/ 		Object.keys(hotAvailableFilesMap).forEach(function(chunkId) {
/******/ 			if (hotAvailableFilesMap[chunkId] === false) {
/******/ 				hotDisposeChunk(chunkId);
/******/ 			}
/******/ 		});
/******/
/******/ 		var idx;
/******/ 		var queue = outdatedModules.slice();
/******/ 		while (queue.length > 0) {
/******/ 			moduleId = queue.pop();
/******/ 			module = installedModules[moduleId];
/******/ 			if (!module) continue;
/******/
/******/ 			var data = {};
/******/
/******/ 			// Call dispose handlers
/******/ 			var disposeHandlers = module.hot._disposeHandlers;
/******/ 			for (j = 0; j < disposeHandlers.length; j++) {
/******/ 				cb = disposeHandlers[j];
/******/ 				cb(data);
/******/ 			}
/******/ 			hotCurrentModuleData[moduleId] = data;
/******/
/******/ 			// disable module (this disables requires from this module)
/******/ 			module.hot.active = false;
/******/
/******/ 			// remove module from cache
/******/ 			delete installedModules[moduleId];
/******/
/******/ 			// when disposing there is no need to call dispose handler
/******/ 			delete outdatedDependencies[moduleId];
/******/
/******/ 			// remove "parents" references from all children
/******/ 			for (j = 0; j < module.children.length; j++) {
/******/ 				var child = installedModules[module.children[j]];
/******/ 				if (!child) continue;
/******/ 				idx = child.parents.indexOf(moduleId);
/******/ 				if (idx >= 0) {
/******/ 					child.parents.splice(idx, 1);
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// remove outdated dependency from module children
/******/ 		var dependency;
/******/ 		var moduleOutdatedDependencies;
/******/ 		for (moduleId in outdatedDependencies) {
/******/ 			if (
/******/ 				Object.prototype.hasOwnProperty.call(outdatedDependencies, moduleId)
/******/ 			) {
/******/ 				module = installedModules[moduleId];
/******/ 				if (module) {
/******/ 					moduleOutdatedDependencies = outdatedDependencies[moduleId];
/******/ 					for (j = 0; j < moduleOutdatedDependencies.length; j++) {
/******/ 						dependency = moduleOutdatedDependencies[j];
/******/ 						idx = module.children.indexOf(dependency);
/******/ 						if (idx >= 0) module.children.splice(idx, 1);
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// Now in "apply" phase
/******/ 		hotSetStatus("apply");
/******/
/******/ 		hotCurrentHash = hotUpdateNewHash;
/******/
/******/ 		// insert new code
/******/ 		for (moduleId in appliedUpdate) {
/******/ 			if (Object.prototype.hasOwnProperty.call(appliedUpdate, moduleId)) {
/******/ 				modules[moduleId] = appliedUpdate[moduleId];
/******/ 			}
/******/ 		}
/******/
/******/ 		// call accept handlers
/******/ 		var error = null;
/******/ 		for (moduleId in outdatedDependencies) {
/******/ 			if (
/******/ 				Object.prototype.hasOwnProperty.call(outdatedDependencies, moduleId)
/******/ 			) {
/******/ 				module = installedModules[moduleId];
/******/ 				if (module) {
/******/ 					moduleOutdatedDependencies = outdatedDependencies[moduleId];
/******/ 					var callbacks = [];
/******/ 					for (i = 0; i < moduleOutdatedDependencies.length; i++) {
/******/ 						dependency = moduleOutdatedDependencies[i];
/******/ 						cb = module.hot._acceptedDependencies[dependency];
/******/ 						if (cb) {
/******/ 							if (callbacks.indexOf(cb) !== -1) continue;
/******/ 							callbacks.push(cb);
/******/ 						}
/******/ 					}
/******/ 					for (i = 0; i < callbacks.length; i++) {
/******/ 						cb = callbacks[i];
/******/ 						try {
/******/ 							cb(moduleOutdatedDependencies);
/******/ 						} catch (err) {
/******/ 							if (options.onErrored) {
/******/ 								options.onErrored({
/******/ 									type: "accept-errored",
/******/ 									moduleId: moduleId,
/******/ 									dependencyId: moduleOutdatedDependencies[i],
/******/ 									error: err
/******/ 								});
/******/ 							}
/******/ 							if (!options.ignoreErrored) {
/******/ 								if (!error) error = err;
/******/ 							}
/******/ 						}
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// Load self accepted modules
/******/ 		for (i = 0; i < outdatedSelfAcceptedModules.length; i++) {
/******/ 			var item = outdatedSelfAcceptedModules[i];
/******/ 			moduleId = item.module;
/******/ 			hotCurrentParents = [moduleId];
/******/ 			try {
/******/ 				__webpack_require__(moduleId);
/******/ 			} catch (err) {
/******/ 				if (typeof item.errorHandler === "function") {
/******/ 					try {
/******/ 						item.errorHandler(err);
/******/ 					} catch (err2) {
/******/ 						if (options.onErrored) {
/******/ 							options.onErrored({
/******/ 								type: "self-accept-error-handler-errored",
/******/ 								moduleId: moduleId,
/******/ 								error: err2,
/******/ 								originalError: err
/******/ 							});
/******/ 						}
/******/ 						if (!options.ignoreErrored) {
/******/ 							if (!error) error = err2;
/******/ 						}
/******/ 						if (!error) error = err;
/******/ 					}
/******/ 				} else {
/******/ 					if (options.onErrored) {
/******/ 						options.onErrored({
/******/ 							type: "self-accept-errored",
/******/ 							moduleId: moduleId,
/******/ 							error: err
/******/ 						});
/******/ 					}
/******/ 					if (!options.ignoreErrored) {
/******/ 						if (!error) error = err;
/******/ 					}
/******/ 				}
/******/ 			}
/******/ 		}
/******/
/******/ 		// handle errors in accept handlers and self accepted module load
/******/ 		if (error) {
/******/ 			hotSetStatus("fail");
/******/ 			return Promise.reject(error);
/******/ 		}
/******/
/******/ 		hotSetStatus("idle");
/******/ 		return new Promise(function(resolve) {
/******/ 			resolve(outdatedModules);
/******/ 		});
/******/ 	}
/******/
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {},
/******/ 			hot: hotCreateModule(moduleId),
/******/ 			parents: (hotCurrentParentsTemp = hotCurrentParents, hotCurrentParents = [], hotCurrentParentsTemp),
/******/ 			children: []
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, hotCreateRequire(moduleId));
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "dist";
/******/
/******/ 	// __webpack_hash__
/******/ 	__webpack_require__.h = function() { return hotCurrentHash; };
/******/
/******/
/******/ 	// Load entry module and return exports
/******/ 	return hotCreateRequire("./src/js/index.js")(__webpack_require__.s = "./src/js/index.js");
/******/ })
/************************************************************************/
/******/ ({

/***/ "./node_modules/tui-code-snippet/array/inArray.js":
/*!********************************************************!*\
  !*** ./node_modules/tui-code-snippet/array/inArray.js ***!
  \********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/* eslint-disable complexity */
/**
 * @fileoverview Returns the first index at which a given element can be found in the array.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var isArray = __webpack_require__(/*! ../type/isArray */ "./node_modules/tui-code-snippet/type/isArray.js");

/**
 * @module array
 */

/**
 * Returns the first index at which a given element can be found in the array
 * from start index(default 0), or -1 if it is not present.
 * It compares searchElement to elements of the Array using strict equality
 * (the same method used by the ===, or triple-equals, operator).
 * @param {*} searchElement Element to locate in the array
 * @param {Array} array Array that will be traversed.
 * @param {number} startIndex Start index in array for searching (default 0)
 * @returns {number} the First index at which a given element, or -1 if it is not present
 * @memberof module:array
 * @example
 * var inArray = require('tui-code-snippet/array/inArray'); // node, commonjs
 *
 * var arr = ['one', 'two', 'three', 'four'];
 * var idx1 = inArray('one', arr, 3); // -1
 * var idx2 = inArray('one', arr); // 0
 */
function inArray(searchElement, array, startIndex) {
    var i;
    var length;
    startIndex = startIndex || 0;

    if (!isArray(array)) {
        return -1;
    }

    if (Array.prototype.indexOf) {
        return Array.prototype.indexOf.call(array, searchElement, startIndex);
    }

    length = array.length;
    for (i = startIndex; startIndex >= 0 && i < length; i += 1) {
        if (array[i] === searchElement) {
            return i;
        }
    }

    return -1;
}

module.exports = inArray;


/***/ }),

/***/ "./node_modules/tui-code-snippet/collection/forEach.js":
/*!*************************************************************!*\
  !*** ./node_modules/tui-code-snippet/collection/forEach.js ***!
  \*************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Execute the provided callback once for each property of object(or element of array) which actually exist.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var isArray = __webpack_require__(/*! ../type/isArray */ "./node_modules/tui-code-snippet/type/isArray.js");
var forEachArray = __webpack_require__(/*! ../collection/forEachArray */ "./node_modules/tui-code-snippet/collection/forEachArray.js");
var forEachOwnProperties = __webpack_require__(/*! ../collection/forEachOwnProperties */ "./node_modules/tui-code-snippet/collection/forEachOwnProperties.js");

/**
 * @module collection
 */

/**
 * Execute the provided callback once for each property of object(or element of array) which actually exist.
 * If the object is Array-like object(ex-arguments object), It needs to transform to Array.(see 'ex2' of example).
 * If the callback function returns false, the loop will be stopped.
 * Callback function(iteratee) is invoked with three arguments:
 *  - The value of the property(or The value of the element)
 *  - The name of the property(or The index of the element)
 *  - The object being traversed
 * @param {Object} obj The object that will be traversed
 * @param {function} iteratee Callback function
 * @param {Object} [context] Context(this) of callback function
 * @memberof module:collection
 * @example
 * var forEach = require('tui-code-snippet/collection/forEach'); // node, commonjs
 *
 * var sum = 0;
 *
 * forEach([1,2,3], function(value){
 *     sum += value;
 * });
 * alert(sum); // 6
 *
 * // In case of Array-like object
 * var array = Array.prototype.slice.call(arrayLike); // change to array
 * forEach(array, function(value){
 *     sum += value;
 * });
 */
function forEach(obj, iteratee, context) {
    if (isArray(obj)) {
        forEachArray(obj, iteratee, context);
    } else {
        forEachOwnProperties(obj, iteratee, context);
    }
}

module.exports = forEach;


/***/ }),

/***/ "./node_modules/tui-code-snippet/collection/forEachArray.js":
/*!******************************************************************!*\
  !*** ./node_modules/tui-code-snippet/collection/forEachArray.js ***!
  \******************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Execute the provided callback once for each element present in the array(or Array-like object) in ascending order.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Execute the provided callback once for each element present
 * in the array(or Array-like object) in ascending order.
 * If the callback function returns false, the loop will be stopped.
 * Callback function(iteratee) is invoked with three arguments:
 *  - The value of the element
 *  - The index of the element
 *  - The array(or Array-like object) being traversed
 * @param {Array} arr The array(or Array-like object) that will be traversed
 * @param {function} iteratee Callback function
 * @param {Object} [context] Context(this) of callback function
 * @memberof module:collection
 * @example
 * var forEachArray = require('tui-code-snippet/collection/forEachArray'); // node, commonjs
 *
 * var sum = 0;
 *
 * forEachArray([1,2,3], function(value){
 *     sum += value;
 * });
 * alert(sum); // 6
 */
function forEachArray(arr, iteratee, context) {
    var index = 0;
    var len = arr.length;

    context = context || null;

    for (; index < len; index += 1) {
        if (iteratee.call(context, arr[index], index, arr) === false) {
            break;
        }
    }
}

module.exports = forEachArray;


/***/ }),

/***/ "./node_modules/tui-code-snippet/collection/forEachOwnProperties.js":
/*!**************************************************************************!*\
  !*** ./node_modules/tui-code-snippet/collection/forEachOwnProperties.js ***!
  \**************************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Execute the provided callback once for each property of object which actually exist.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Execute the provided callback once for each property of object which actually exist.
 * If the callback function returns false, the loop will be stopped.
 * Callback function(iteratee) is invoked with three arguments:
 *  - The value of the property
 *  - The name of the property
 *  - The object being traversed
 * @param {Object} obj The object that will be traversed
 * @param {function} iteratee  Callback function
 * @param {Object} [context] Context(this) of callback function
 * @memberof module:collection
 * @example
 * var forEachOwnProperties = require('tui-code-snippet/collection/forEachOwnProperties'); // node, commonjs
 *
 * var sum = 0;
 *
 * forEachOwnProperties({a:1,b:2,c:3}, function(value){
 *     sum += value;
 * });
 * alert(sum); // 6
 */
function forEachOwnProperties(obj, iteratee, context) {
    var key;

    context = context || null;

    for (key in obj) {
        if (obj.hasOwnProperty(key)) {
            if (iteratee.call(context, obj[key], key, obj) === false) {
                break;
            }
        }
    }
}

module.exports = forEachOwnProperties;


/***/ }),

/***/ "./node_modules/tui-code-snippet/collection/toArray.js":
/*!*************************************************************!*\
  !*** ./node_modules/tui-code-snippet/collection/toArray.js ***!
  \*************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Transform the Array-like object to Array.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var forEachArray = __webpack_require__(/*! ./forEachArray */ "./node_modules/tui-code-snippet/collection/forEachArray.js");

/**
 * Transform the Array-like object to Array.
 * In low IE (below 8), Array.prototype.slice.call is not perfect. So, try-catch statement is used.
 * @param {*} arrayLike Array-like object
 * @returns {Array} Array
 * @memberof module:collection
 * @example
 * var toArray = require('tui-code-snippet/collection/toArray'); // node, commonjs
 *
 * var arrayLike = {
 *     0: 'one',
 *     1: 'two',
 *     2: 'three',
 *     3: 'four',
 *     length: 4
 * };
 * var result = toArray(arrayLike);
 *
 * alert(result instanceof Array); // true
 * alert(result); // one,two,three,four
 */
function toArray(arrayLike) {
    var arr;
    try {
        arr = Array.prototype.slice.call(arrayLike);
    } catch (e) {
        arr = [];
        forEachArray(arrayLike, function(value) {
            arr.push(value);
        });
    }

    return arr;
}

module.exports = toArray;


/***/ }),

/***/ "./node_modules/tui-code-snippet/customEvents/customEvents.js":
/*!********************************************************************!*\
  !*** ./node_modules/tui-code-snippet/customEvents/customEvents.js ***!
  \********************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview This module provides some functions for custom events. And it is implemented in the observer design pattern.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var extend = __webpack_require__(/*! ../object/extend */ "./node_modules/tui-code-snippet/object/extend.js");
var isExisty = __webpack_require__(/*! ../type/isExisty */ "./node_modules/tui-code-snippet/type/isExisty.js");
var isString = __webpack_require__(/*! ../type/isString */ "./node_modules/tui-code-snippet/type/isString.js");
var isObject = __webpack_require__(/*! ../type/isObject */ "./node_modules/tui-code-snippet/type/isObject.js");
var isArray = __webpack_require__(/*! ../type/isArray */ "./node_modules/tui-code-snippet/type/isArray.js");
var isFunction = __webpack_require__(/*! ../type/isFunction */ "./node_modules/tui-code-snippet/type/isFunction.js");
var forEach = __webpack_require__(/*! ../collection/forEach */ "./node_modules/tui-code-snippet/collection/forEach.js");

var R_EVENTNAME_SPLIT = /\s+/g;

/**
 * @class
 * @example
 * // node, commonjs
 * var CustomEvents = require('tui-code-snippet/customEvents/customEvents');
 */
function CustomEvents() {
    /**
     * @type {HandlerItem[]}
     */
    this.events = null;

    /**
     * only for checking specific context event was binded
     * @type {object[]}
     */
    this.contexts = null;
}

/**
 * Mixin custom events feature to specific constructor
 * @param {function} func - constructor
 * @example
 * var CustomEvents = require('tui-code-snippet/customEvents/customEvents'); // node, commonjs
 *
 * var model;
 * function Model() {
 *     this.name = '';
 * }
 * CustomEvents.mixin(Model);
 *
 * model = new Model();
 * model.on('change', function() { this.name = 'model'; }, this);
 * model.fire('change');
 * alert(model.name); // 'model';
 */
CustomEvents.mixin = function(func) {
    extend(func.prototype, CustomEvents.prototype);
};

/**
 * Get HandlerItem object
 * @param {function} handler - handler function
 * @param {object} [context] - context for handler
 * @returns {HandlerItem} HandlerItem object
 * @private
 */
CustomEvents.prototype._getHandlerItem = function(handler, context) {
    var item = {handler: handler};

    if (context) {
        item.context = context;
    }

    return item;
};

/**
 * Get event object safely
 * @param {string} [eventName] - create sub event map if not exist.
 * @returns {(object|array)} event object. if you supplied `eventName`
 *  parameter then make new array and return it
 * @private
 */
CustomEvents.prototype._safeEvent = function(eventName) {
    var events = this.events;
    var byName;

    if (!events) {
        events = this.events = {};
    }

    if (eventName) {
        byName = events[eventName];

        if (!byName) {
            byName = [];
            events[eventName] = byName;
        }

        events = byName;
    }

    return events;
};

/**
 * Get context array safely
 * @returns {array} context array
 * @private
 */
CustomEvents.prototype._safeContext = function() {
    var context = this.contexts;

    if (!context) {
        context = this.contexts = [];
    }

    return context;
};

/**
 * Get index of context
 * @param {object} ctx - context that used for bind custom event
 * @returns {number} index of context
 * @private
 */
CustomEvents.prototype._indexOfContext = function(ctx) {
    var context = this._safeContext();
    var index = 0;

    while (context[index]) {
        if (ctx === context[index][0]) {
            return index;
        }

        index += 1;
    }

    return -1;
};

/**
 * Memorize supplied context for recognize supplied object is context or
 *  name: handler pair object when off()
 * @param {object} ctx - context object to memorize
 * @private
 */
CustomEvents.prototype._memorizeContext = function(ctx) {
    var context, index;

    if (!isExisty(ctx)) {
        return;
    }

    context = this._safeContext();
    index = this._indexOfContext(ctx);

    if (index > -1) {
        context[index][1] += 1;
    } else {
        context.push([ctx, 1]);
    }
};

/**
 * Forget supplied context object
 * @param {object} ctx - context object to forget
 * @private
 */
CustomEvents.prototype._forgetContext = function(ctx) {
    var context, contextIndex;

    if (!isExisty(ctx)) {
        return;
    }

    context = this._safeContext();
    contextIndex = this._indexOfContext(ctx);

    if (contextIndex > -1) {
        context[contextIndex][1] -= 1;

        if (context[contextIndex][1] <= 0) {
            context.splice(contextIndex, 1);
        }
    }
};

/**
 * Bind event handler
 * @param {(string|{name:string, handler:function})} eventName - custom
 *  event name or an object {eventName: handler}
 * @param {(function|object)} [handler] - handler function or context
 * @param {object} [context] - context for binding
 * @private
 */
CustomEvents.prototype._bindEvent = function(eventName, handler, context) {
    var events = this._safeEvent(eventName);
    this._memorizeContext(context);
    events.push(this._getHandlerItem(handler, context));
};

/**
 * Bind event handlers
 * @param {(string|{name:string, handler:function})} eventName - custom
 *  event name or an object {eventName: handler}
 * @param {(function|object)} [handler] - handler function or context
 * @param {object} [context] - context for binding
 * //-- #1. Get Module --//
 * var CustomEvents = require('tui-code-snippet/customEvents/customEvents'); // node, commonjs
 *
 * //-- #2. Use method --//
 * // # 2.1 Basic Usage
 * CustomEvents.on('onload', handler);
 *
 * // # 2.2 With context
 * CustomEvents.on('onload', handler, myObj);
 *
 * // # 2.3 Bind by object that name, handler pairs
 * CustomEvents.on({
 *     'play': handler,
 *     'pause': handler2
 * });
 *
 * // # 2.4 Bind by object that name, handler pairs with context object
 * CustomEvents.on({
 *     'play': handler
 * }, myObj);
 */
CustomEvents.prototype.on = function(eventName, handler, context) {
    var self = this;

    if (isString(eventName)) {
        // [syntax 1, 2]
        eventName = eventName.split(R_EVENTNAME_SPLIT);
        forEach(eventName, function(name) {
            self._bindEvent(name, handler, context);
        });
    } else if (isObject(eventName)) {
        // [syntax 3, 4]
        context = handler;
        forEach(eventName, function(func, name) {
            self.on(name, func, context);
        });
    }
};

/**
 * Bind one-shot event handlers
 * @param {(string|{name:string,handler:function})} eventName - custom
 *  event name or an object {eventName: handler}
 * @param {function|object} [handler] - handler function or context
 * @param {object} [context] - context for binding
 */
CustomEvents.prototype.once = function(eventName, handler, context) {
    var self = this;

    if (isObject(eventName)) {
        context = handler;
        forEach(eventName, function(func, name) {
            self.once(name, func, context);
        });

        return;
    }

    function onceHandler() { // eslint-disable-line require-jsdoc
        handler.apply(context, arguments);
        self.off(eventName, onceHandler, context);
    }

    this.on(eventName, onceHandler, context);
};

/**
 * Splice supplied array by callback result
 * @param {array} arr - array to splice
 * @param {function} predicate - function return boolean
 * @private
 */
CustomEvents.prototype._spliceMatches = function(arr, predicate) {
    var i = 0;
    var len;

    if (!isArray(arr)) {
        return;
    }

    for (len = arr.length; i < len; i += 1) {
        if (predicate(arr[i]) === true) {
            arr.splice(i, 1);
            len -= 1;
            i -= 1;
        }
    }
};

/**
 * Get matcher for unbind specific handler events
 * @param {function} handler - handler function
 * @returns {function} handler matcher
 * @private
 */
CustomEvents.prototype._matchHandler = function(handler) {
    var self = this;

    return function(item) {
        var needRemove = handler === item.handler;

        if (needRemove) {
            self._forgetContext(item.context);
        }

        return needRemove;
    };
};

/**
 * Get matcher for unbind specific context events
 * @param {object} context - context
 * @returns {function} object matcher
 * @private
 */
CustomEvents.prototype._matchContext = function(context) {
    var self = this;

    return function(item) {
        var needRemove = context === item.context;

        if (needRemove) {
            self._forgetContext(item.context);
        }

        return needRemove;
    };
};

/**
 * Get matcher for unbind specific hander, context pair events
 * @param {function} handler - handler function
 * @param {object} context - context
 * @returns {function} handler, context matcher
 * @private
 */
CustomEvents.prototype._matchHandlerAndContext = function(handler, context) {
    var self = this;

    return function(item) {
        var matchHandler = (handler === item.handler);
        var matchContext = (context === item.context);
        var needRemove = (matchHandler && matchContext);

        if (needRemove) {
            self._forgetContext(item.context);
        }

        return needRemove;
    };
};

/**
 * Unbind event by event name
 * @param {string} eventName - custom event name to unbind
 * @param {function} [handler] - handler function
 * @private
 */
CustomEvents.prototype._offByEventName = function(eventName, handler) {
    var self = this;
    var andByHandler = isFunction(handler);
    var matchHandler = self._matchHandler(handler);

    eventName = eventName.split(R_EVENTNAME_SPLIT);

    forEach(eventName, function(name) {
        var handlerItems = self._safeEvent(name);

        if (andByHandler) {
            self._spliceMatches(handlerItems, matchHandler);
        } else {
            forEach(handlerItems, function(item) {
                self._forgetContext(item.context);
            });

            self.events[name] = [];
        }
    });
};

/**
 * Unbind event by handler function
 * @param {function} handler - handler function
 * @private
 */
CustomEvents.prototype._offByHandler = function(handler) {
    var self = this;
    var matchHandler = this._matchHandler(handler);

    forEach(this._safeEvent(), function(handlerItems) {
        self._spliceMatches(handlerItems, matchHandler);
    });
};

/**
 * Unbind event by object(name: handler pair object or context object)
 * @param {object} obj - context or {name: handler} pair object
 * @param {function} handler - handler function
 * @private
 */
CustomEvents.prototype._offByObject = function(obj, handler) {
    var self = this;
    var matchFunc;

    if (this._indexOfContext(obj) < 0) {
        forEach(obj, function(func, name) {
            self.off(name, func);
        });
    } else if (isString(handler)) {
        matchFunc = this._matchContext(obj);

        self._spliceMatches(this._safeEvent(handler), matchFunc);
    } else if (isFunction(handler)) {
        matchFunc = this._matchHandlerAndContext(handler, obj);

        forEach(this._safeEvent(), function(handlerItems) {
            self._spliceMatches(handlerItems, matchFunc);
        });
    } else {
        matchFunc = this._matchContext(obj);

        forEach(this._safeEvent(), function(handlerItems) {
            self._spliceMatches(handlerItems, matchFunc);
        });
    }
};

/**
 * Unbind custom events
 * @param {(string|object|function)} eventName - event name or context or
 *  {name: handler} pair object or handler function
 * @param {(function)} handler - handler function
 * @example
 * //-- #1. Get Module --//
 * var CustomEvents = require('tui-code-snippet/customEvents/customEvents'); // node, commonjs
 *
 * //-- #2. Use method --//
 * // # 2.1 off by event name
 * CustomEvents.off('onload');
 *
 * // # 2.2 off by event name and handler
 * CustomEvents.off('play', handler);
 *
 * // # 2.3 off by handler
 * CustomEvents.off(handler);
 *
 * // # 2.4 off by context
 * CustomEvents.off(myObj);
 *
 * // # 2.5 off by context and handler
 * CustomEvents.off(myObj, handler);
 *
 * // # 2.6 off by context and event name
 * CustomEvents.off(myObj, 'onload');
 *
 * // # 2.7 off by an Object.<string, function> that is {eventName: handler}
 * CustomEvents.off({
 *   'play': handler,
 *   'pause': handler2
 * });
 *
 * // # 2.8 off the all events
 * CustomEvents.off();
 */
CustomEvents.prototype.off = function(eventName, handler) {
    if (isString(eventName)) {
        // [syntax 1, 2]
        this._offByEventName(eventName, handler);
    } else if (!arguments.length) {
        // [syntax 8]
        this.events = {};
        this.contexts = [];
    } else if (isFunction(eventName)) {
        // [syntax 3]
        this._offByHandler(eventName);
    } else if (isObject(eventName)) {
        // [syntax 4, 5, 6]
        this._offByObject(eventName, handler);
    }
};

/**
 * Fire custom event
 * @param {string} eventName - name of custom event
 */
CustomEvents.prototype.fire = function(eventName) {  // eslint-disable-line
    this.invoke.apply(this, arguments);
};

/**
 * Fire a event and returns the result of operation 'boolean AND' with all
 *  listener's results.
 *
 * So, It is different from {@link CustomEvents#fire}.
 *
 * In service code, use this as a before event in component level usually
 *  for notifying that the event is cancelable.
 * @param {string} eventName - Custom event name
 * @param {...*} data - Data for event
 * @returns {boolean} The result of operation 'boolean AND'
 * @example
 * var map = new Map();
 * map.on({
 *     'beforeZoom': function() {
 *         // It should cancel the 'zoom' event by some conditions.
 *         if (that.disabled && this.getState()) {
 *             return false;
 *         }
 *         return true;
 *     }
 * });
 *
 * if (this.invoke('beforeZoom')) {    // check the result of 'beforeZoom'
 *     // if true,
 *     // doSomething
 * }
 */
CustomEvents.prototype.invoke = function(eventName) {
    var events, args, index, item;

    if (!this.hasListener(eventName)) {
        return true;
    }

    events = this._safeEvent(eventName);
    args = Array.prototype.slice.call(arguments, 1);
    index = 0;

    while (events[index]) {
        item = events[index];

        if (item.handler.apply(item.context, args) === false) {
            return false;
        }

        index += 1;
    }

    return true;
};

/**
 * Return whether at least one of the handlers is registered in the given
 *  event name.
 * @param {string} eventName - Custom event name
 * @returns {boolean} Is there at least one handler in event name?
 */
CustomEvents.prototype.hasListener = function(eventName) {
    return this.getListenerLength(eventName) > 0;
};

/**
 * Return a count of events registered.
 * @param {string} eventName - Custom event name
 * @returns {number} number of event
 */
CustomEvents.prototype.getListenerLength = function(eventName) {
    var events = this._safeEvent(eventName);

    return events.length;
};

module.exports = CustomEvents;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domEvent/_safeEvent.js":
/*!**************************************************************!*\
  !*** ./node_modules/tui-code-snippet/domEvent/_safeEvent.js ***!
  \**************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Get event collection for specific HTML element
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var EVENT_KEY = '_feEventKey';

/**
 * Get event collection for specific HTML element
 * @param {HTMLElement} element - HTML element
 * @param {string} type - event type
 * @returns {array}
 * @private
 */
function safeEvent(element, type) {
    var events = element[EVENT_KEY];
    var handlers;

    if (!events) {
        events = element[EVENT_KEY] = {};
    }

    handlers = events[type];
    if (!handlers) {
        handlers = events[type] = [];
    }

    return handlers;
}

module.exports = safeEvent;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domEvent/getTarget.js":
/*!*************************************************************!*\
  !*** ./node_modules/tui-code-snippet/domEvent/getTarget.js ***!
  \*************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Get a target element from an event object.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Get a target element from an event object.
 * @param {Event} e - event object
 * @returns {HTMLElement} - target element
 * @memberof module:domEvent
 */
function getTarget(e) {
    return e.target || e.srcElement;
}

module.exports = getTarget;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domEvent/off.js":
/*!*******************************************************!*\
  !*** ./node_modules/tui-code-snippet/domEvent/off.js ***!
  \*******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Unbind DOM events
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var isString = __webpack_require__(/*! ../type/isString */ "./node_modules/tui-code-snippet/type/isString.js");
var forEach = __webpack_require__(/*! ../collection/forEach */ "./node_modules/tui-code-snippet/collection/forEach.js");

var safeEvent = __webpack_require__(/*! ./_safeEvent */ "./node_modules/tui-code-snippet/domEvent/_safeEvent.js");

/**
 * Unbind DOM events
 * If a handler function is not passed, remove all events of that type.
 * @param {HTMLElement} element - element to unbindbind events
 * @param {(string|object)} types - Space splitted events names or
 *  eventName:handler object
 * @param {function} [handler] - handler function
 * @memberof module:domEvent
 */
function off(element, types, handler) {
    if (isString(types)) {
        forEach(types.split(/\s+/g), function(type) {
            unbindEvent(element, type, handler);
        });

        return;
    }

    forEach(types, function(func, type) {
        unbindEvent(element, type, func);
    });
}

/**
 * Unbind DOM events
 * If a handler function is not passed, remove all events of that type.
 * @param {HTMLElement} element - element to unbind events
 * @param {string} type - events name
 * @param {function} [handler] - handler function
 * @private
 */
function unbindEvent(element, type, handler) {
    var events = safeEvent(element, type);
    var index;

    if (!handler) {
        forEach(events, function(item) {
            removeHandler(element, type, item.wrappedHandler);
        });
        events.splice(0, events.length);
    } else {
        forEach(events, function(item, idx) {
            if (handler === item.handler) {
                removeHandler(element, type, item.wrappedHandler);
                index = idx;

                return false;
            }

            return true;
        });
        events.splice(index, 1);
    }
}

/**
 * Remove an event handler
 * @param {HTMLElement} element - An element to remove an event
 * @param {string} type - event type
 * @param {function} handler - event handler
 * @private
 */
function removeHandler(element, type, handler) {
    if ('removeEventListener' in element) {
        element.removeEventListener(type, handler);
    } else if ('detachEvent' in element) {
        element.detachEvent('on' + type, handler);
    }
}

module.exports = off;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domEvent/on.js":
/*!******************************************************!*\
  !*** ./node_modules/tui-code-snippet/domEvent/on.js ***!
  \******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Bind DOM events
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var isString = __webpack_require__(/*! ../type/isString */ "./node_modules/tui-code-snippet/type/isString.js");
var forEach = __webpack_require__(/*! ../collection/forEach */ "./node_modules/tui-code-snippet/collection/forEach.js");

var safeEvent = __webpack_require__(/*! ./_safeEvent */ "./node_modules/tui-code-snippet/domEvent/_safeEvent.js");

/**
 * Bind DOM events
 * @param {HTMLElement} element - element to bind events
 * @param {(string|object)} types - Space splitted events names or
 *  eventName:handler object
 * @param {(function|object)} handler - handler function or context for handler
 *  method
 * @param {object} [context] context - context for handler method.
 * @memberof module:domEvent
 */
function on(element, types, handler, context) {
    if (isString(types)) {
        forEach(types.split(/\s+/g), function(type) {
            bindEvent(element, type, handler, context);
        });

        return;
    }

    forEach(types, function(func, type) {
        bindEvent(element, type, func, handler);
    });
}

/**
 * Bind DOM events
 * @param {HTMLElement} element - element to bind events
 * @param {string} type - events name
 * @param {function} handler - handler function or context for handler
 *  method
 * @param {object} [context] context - context for handler method.
 * @private
 */
function bindEvent(element, type, handler, context) {
    /**
     * Event handler
     * @param {Event} e - event object
     */
    function eventHandler(e) {
        handler.call(context || element, e || window.event);
    }

    if ('addEventListener' in element) {
        element.addEventListener(type, eventHandler);
    } else if ('attachEvent' in element) {
        element.attachEvent('on' + type, eventHandler);
    }
    memorizeHandler(element, type, handler, eventHandler);
}

/**
 * Memorize DOM event handler for unbinding.
 * @param {HTMLElement} element - element to bind events
 * @param {string} type - events name
 * @param {function} handler - handler function that user passed at on() use
 * @param {function} wrappedHandler - handler function that wrapped by domevent for implementing some features
 * @private
 */
function memorizeHandler(element, type, handler, wrappedHandler) {
    var events = safeEvent(element, type);
    var existInEvents = false;

    forEach(events, function(obj) {
        if (obj.handler === handler) {
            existInEvents = true;

            return false;
        }

        return true;
    });

    if (!existInEvents) {
        events.push({
            handler: handler,
            wrappedHandler: wrappedHandler
        });
    }
}

module.exports = on;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domEvent/preventDefault.js":
/*!******************************************************************!*\
  !*** ./node_modules/tui-code-snippet/domEvent/preventDefault.js ***!
  \******************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Prevent default action
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Prevent default action
 * @param {Event} e - event object
 * @memberof module:domEvent
 */
function preventDefault(e) {
    if (e.preventDefault) {
        e.preventDefault();

        return;
    }

    e.returnValue = false;
}

module.exports = preventDefault;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domUtil/_setClassName.js":
/*!****************************************************************!*\
  !*** ./node_modules/tui-code-snippet/domUtil/_setClassName.js ***!
  \****************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Set className value
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var isArray = __webpack_require__(/*! ../type/isArray */ "./node_modules/tui-code-snippet/type/isArray.js");
var isUndefined = __webpack_require__(/*! ../type/isUndefined */ "./node_modules/tui-code-snippet/type/isUndefined.js");

/**
 * Set className value
 * @param {(HTMLElement|SVGElement)} element - target element
 * @param {(string|string[])} cssClass - class names
 * @private
 */
function setClassName(element, cssClass) {
    cssClass = isArray(cssClass) ? cssClass.join(' ') : cssClass;

    cssClass = cssClass.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');

    if (isUndefined(element.className.baseVal)) {
        element.className = cssClass;

        return;
    }

    element.className.baseVal = cssClass;
}

module.exports = setClassName;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domUtil/addClass.js":
/*!***********************************************************!*\
  !*** ./node_modules/tui-code-snippet/domUtil/addClass.js ***!
  \***********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Add css class to element
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var forEach = __webpack_require__(/*! ../collection/forEach */ "./node_modules/tui-code-snippet/collection/forEach.js");
var inArray = __webpack_require__(/*! ../array/inArray */ "./node_modules/tui-code-snippet/array/inArray.js");
var getClass = __webpack_require__(/*! ./getClass */ "./node_modules/tui-code-snippet/domUtil/getClass.js");
var setClassName = __webpack_require__(/*! ./_setClassName */ "./node_modules/tui-code-snippet/domUtil/_setClassName.js");

/**
 * domUtil module
 * @module domUtil
 */

/**
 * Add css class to element
 * @param {(HTMLElement|SVGElement)} element - target element
 * @param {...string} cssClass - css classes to add
 * @memberof module:domUtil
 */
function addClass(element) {
    var cssClass = Array.prototype.slice.call(arguments, 1);
    var classList = element.classList;
    var newClass = [];
    var origin;

    if (classList) {
        forEach(cssClass, function(name) {
            element.classList.add(name);
        });

        return;
    }

    origin = getClass(element);

    if (origin) {
        cssClass = [].concat(origin.split(/\s+/), cssClass);
    }

    forEach(cssClass, function(cls) {
        if (inArray(cls, newClass) < 0) {
            newClass.push(cls);
        }
    });

    setClassName(element, newClass);
}

module.exports = addClass;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domUtil/closest.js":
/*!**********************************************************!*\
  !*** ./node_modules/tui-code-snippet/domUtil/closest.js ***!
  \**********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Find parent element recursively
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var matches = __webpack_require__(/*! ./matches */ "./node_modules/tui-code-snippet/domUtil/matches.js");

/**
 * Find parent element recursively
 * @param {HTMLElement} element - base element to start find
 * @param {string} selector - selector string for find
 * @returns {HTMLElement} - element finded or null
 * @memberof module:domUtil
 */
function closest(element, selector) {
    var parent = element.parentNode;

    if (matches(element, selector)) {
        return element;
    }

    while (parent && parent !== document) {
        if (matches(parent, selector)) {
            return parent;
        }

        parent = parent.parentNode;
    }

    return null;
}

module.exports = closest;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domUtil/getClass.js":
/*!***********************************************************!*\
  !*** ./node_modules/tui-code-snippet/domUtil/getClass.js ***!
  \***********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Get HTML element's design classes.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var isUndefined = __webpack_require__(/*! ../type/isUndefined */ "./node_modules/tui-code-snippet/type/isUndefined.js");

/**
 * Get HTML element's design classes.
 * @param {(HTMLElement|SVGElement)} element target element
 * @returns {string} element css class name
 * @memberof module:domUtil
 */
function getClass(element) {
    if (!element || !element.className) {
        return '';
    }

    if (isUndefined(element.className.baseVal)) {
        return element.className;
    }

    return element.className.baseVal;
}

module.exports = getClass;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domUtil/matches.js":
/*!**********************************************************!*\
  !*** ./node_modules/tui-code-snippet/domUtil/matches.js ***!
  \**********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check element match selector
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var inArray = __webpack_require__(/*! ../array/inArray */ "./node_modules/tui-code-snippet/array/inArray.js");
var toArray = __webpack_require__(/*! ../collection/toArray */ "./node_modules/tui-code-snippet/collection/toArray.js");

var elProto = Element.prototype;
var matchSelector = elProto.matches ||
    elProto.webkitMatchesSelector ||
    elProto.mozMatchesSelector ||
    elProto.msMatchesSelector ||
    function(selector) {
        var doc = this.document || this.ownerDocument;

        return inArray(this, toArray(doc.querySelectorAll(selector))) > -1;
    };

/**
 * Check element match selector
 * @param {HTMLElement} element - element to check
 * @param {string} selector - selector to check
 * @returns {boolean} is selector matched to element?
 * @memberof module:domUtil
 */
function matches(element, selector) {
    return matchSelector.call(element, selector);
}

module.exports = matches;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domUtil/removeClass.js":
/*!**************************************************************!*\
  !*** ./node_modules/tui-code-snippet/domUtil/removeClass.js ***!
  \**************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Remove css class from element
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var forEachArray = __webpack_require__(/*! ../collection/forEachArray */ "./node_modules/tui-code-snippet/collection/forEachArray.js");
var inArray = __webpack_require__(/*! ../array/inArray */ "./node_modules/tui-code-snippet/array/inArray.js");
var getClass = __webpack_require__(/*! ./getClass */ "./node_modules/tui-code-snippet/domUtil/getClass.js");
var setClassName = __webpack_require__(/*! ./_setClassName */ "./node_modules/tui-code-snippet/domUtil/_setClassName.js");

/**
 * Remove css class from element
 * @param {(HTMLElement|SVGElement)} element - target element
 * @param {...string} cssClass - css classes to remove
 * @memberof module:domUtil
 */
function removeClass(element) {
    var cssClass = Array.prototype.slice.call(arguments, 1);
    var classList = element.classList;
    var origin, newClass;

    if (classList) {
        forEachArray(cssClass, function(name) {
            classList.remove(name);
        });

        return;
    }

    origin = getClass(element).split(/\s+/);
    newClass = [];
    forEachArray(origin, function(name) {
        if (inArray(name, cssClass) < 0) {
            newClass.push(name);
        }
    });

    setClassName(element, newClass);
}

module.exports = removeClass;


/***/ }),

/***/ "./node_modules/tui-code-snippet/domUtil/removeElement.js":
/*!****************************************************************!*\
  !*** ./node_modules/tui-code-snippet/domUtil/removeElement.js ***!
  \****************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Remove element from parent node.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Remove element from parent node.
 * @param {HTMLElement} element - element to remove.
 * @memberof module:domUtil
 */
function removeElement(element) {
    if (element && element.parentNode) {
        element.parentNode.removeChild(element);
    }
}

module.exports = removeElement;


/***/ }),

/***/ "./node_modules/tui-code-snippet/object/extend.js":
/*!********************************************************!*\
  !*** ./node_modules/tui-code-snippet/object/extend.js ***!
  \********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Extend the target object from other objects.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * @module object
 */

/**
 * Extend the target object from other objects.
 * @param {object} target - Object that will be extended
 * @param {...object} objects - Objects as sources
 * @returns {object} Extended object
 * @memberof module:object
 */
function extend(target, objects) { // eslint-disable-line no-unused-vars
    var hasOwnProp = Object.prototype.hasOwnProperty;
    var source, prop, i, len;

    for (i = 1, len = arguments.length; i < len; i += 1) {
        source = arguments[i];
        for (prop in source) {
            if (hasOwnProp.call(source, prop)) {
                target[prop] = source[prop];
            }
        }
    }

    return target;
}

module.exports = extend;


/***/ }),

/***/ "./node_modules/tui-code-snippet/request/imagePing.js":
/*!************************************************************!*\
  !*** ./node_modules/tui-code-snippet/request/imagePing.js ***!
  \************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Request image ping.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var forEachOwnProperties = __webpack_require__(/*! ../collection/forEachOwnProperties */ "./node_modules/tui-code-snippet/collection/forEachOwnProperties.js");

/**
 * @module request
 */

/**
 * Request image ping.
 * @param {String} url url for ping request
 * @param {Object} trackingInfo infos for make query string
 * @returns {HTMLElement}
 * @memberof module:request
 * @example
 * var imagePing = require('tui-code-snippet/request/imagePing'); // node, commonjs
 *
 * imagePing('https://www.google-analytics.com/collect', {
 *     v: 1,
 *     t: 'event',
 *     tid: 'trackingid',
 *     cid: 'cid',
 *     dp: 'dp',
 *     dh: 'dh'
 * });
 */
function imagePing(url, trackingInfo) {
    var trackingElement = document.createElement('img');
    var queryString = '';
    forEachOwnProperties(trackingInfo, function(value, key) {
        queryString += '&' + key + '=' + value;
    });
    queryString = queryString.substring(1);

    trackingElement.src = url + '?' + queryString;

    trackingElement.style.display = 'none';
    document.body.appendChild(trackingElement);
    document.body.removeChild(trackingElement);

    return trackingElement;
}

module.exports = imagePing;


/***/ }),

/***/ "./node_modules/tui-code-snippet/request/sendHostname.js":
/*!***************************************************************!*\
  !*** ./node_modules/tui-code-snippet/request/sendHostname.js ***!
  \***************************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Send hostname on DOMContentLoaded.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var isUndefined = __webpack_require__(/*! ../type/isUndefined */ "./node_modules/tui-code-snippet/type/isUndefined.js");
var imagePing = __webpack_require__(/*! ./imagePing */ "./node_modules/tui-code-snippet/request/imagePing.js");

var ms7days = 7 * 24 * 60 * 60 * 1000;

/**
 * Check if the date has passed 7 days
 * @param {number} date - milliseconds
 * @returns {boolean}
 * @private
 */
function isExpired(date) {
    var now = new Date().getTime();

    return now - date > ms7days;
}

/**
 * Send hostname on DOMContentLoaded.
 * To prevent hostname set tui.usageStatistics to false.
 * @param {string} appName - application name
 * @param {string} trackingId - GA tracking ID
 * @ignore
 */
function sendHostname(appName, trackingId) {
    var url = 'https://www.google-analytics.com/collect';
    var hostname = location.hostname;
    var hitType = 'event';
    var eventCategory = 'use';
    var applicationKeyForStorage = 'TOAST UI ' + appName + ' for ' + hostname + ': Statistics';
    var date = window.localStorage.getItem(applicationKeyForStorage);

    // skip if the flag is defined and is set to false explicitly
    if (!isUndefined(window.tui) && window.tui.usageStatistics === false) {
        return;
    }

    // skip if not pass seven days old
    if (date && !isExpired(date)) {
        return;
    }

    window.localStorage.setItem(applicationKeyForStorage, new Date().getTime());

    setTimeout(function() {
        if (document.readyState === 'interactive' || document.readyState === 'complete') {
            imagePing(url, {
                v: 1,
                t: hitType,
                tid: trackingId,
                cid: hostname,
                dp: hostname,
                dh: appName,
                el: appName,
                ec: eventCategory
            });
        }
    }, 1000);
}

module.exports = sendHostname;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isArray.js":
/*!*******************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isArray.js ***!
  \*******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is an instance of Array or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Check whether the given variable is an instance of Array or not.
 * If the given variable is an instance of Array, return true.
 * @param {*} obj - Target for checking
 * @returns {boolean} Is array instance?
 * @memberof module:type
 */
function isArray(obj) {
    return obj instanceof Array;
}

module.exports = isArray;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isBoolean.js":
/*!*********************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isBoolean.js ***!
  \*********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is a string or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Check whether the given variable is a boolean or not.
 *  If the given variable is a boolean, return true.
 * @param {*} obj - Target for checking
 * @returns {boolean} Is boolean?
 * @memberof module:type
 */
function isBoolean(obj) {
    return typeof obj === 'boolean' || obj instanceof Boolean;
}

module.exports = isBoolean;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isExisty.js":
/*!********************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isExisty.js ***!
  \********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is existing or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



var isUndefined = __webpack_require__(/*! ./isUndefined */ "./node_modules/tui-code-snippet/type/isUndefined.js");
var isNull = __webpack_require__(/*! ./isNull */ "./node_modules/tui-code-snippet/type/isNull.js");

/**
 * Check whether the given variable is existing or not.
 * If the given variable is not null and not undefined, returns true.
 * @param {*} param - Target for checking
 * @returns {boolean} Is existy?
 * @memberof module:type
 * @example
 * var isExisty = require('tui-code-snippet/type/isExisty'); // node, commonjs
 *
 * isExisty(''); //true
 * isExisty(0); //true
 * isExisty([]); //true
 * isExisty({}); //true
 * isExisty(null); //false
 * isExisty(undefined); //false
*/
function isExisty(param) {
    return !isUndefined(param) && !isNull(param);
}

module.exports = isExisty;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isFunction.js":
/*!**********************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isFunction.js ***!
  \**********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is a function or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Check whether the given variable is a function or not.
 * If the given variable is a function, return true.
 * @param {*} obj - Target for checking
 * @returns {boolean} Is function?
 * @memberof module:type
 */
function isFunction(obj) {
    return obj instanceof Function;
}

module.exports = isFunction;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isHTMLNode.js":
/*!**********************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isHTMLNode.js ***!
  \**********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is a instance of HTMLNode or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Check whether the given variable is a instance of HTMLNode or not.
 * If the given variables is a instance of HTMLNode, return true.
 * @param {*} html - Target for checking
 * @returns {boolean} Is HTMLNode ?
 * @memberof module:type
 */
function isHTMLNode(html) {
    if (typeof HTMLElement === 'object') {
        return (html && (html instanceof HTMLElement || !!html.nodeType));
    }

    return !!(html && html.nodeType);
}

module.exports = isHTMLNode;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isNull.js":
/*!******************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isNull.js ***!
  \******************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is null or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Check whether the given variable is null or not.
 * If the given variable(arguments[0]) is null, returns true.
 * @param {*} obj - Target for checking
 * @returns {boolean} Is null?
 * @memberof module:type
 */
function isNull(obj) {
    return obj === null;
}

module.exports = isNull;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isNumber.js":
/*!********************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isNumber.js ***!
  \********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is a number or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Check whether the given variable is a number or not.
 * If the given variable is a number, return true.
 * @param {*} obj - Target for checking
 * @returns {boolean} Is number?
 * @memberof module:type
 */
function isNumber(obj) {
    return typeof obj === 'number' || obj instanceof Number;
}

module.exports = isNumber;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isObject.js":
/*!********************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isObject.js ***!
  \********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is an object or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Check whether the given variable is an object or not.
 * If the given variable is an object, return true.
 * @param {*} obj - Target for checking
 * @returns {boolean} Is object?
 * @memberof module:type
 */
function isObject(obj) {
    return obj === Object(obj);
}

module.exports = isObject;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isString.js":
/*!********************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isString.js ***!
  \********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is a string or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Check whether the given variable is a string or not.
 * If the given variable is a string, return true.
 * @param {*} obj - Target for checking
 * @returns {boolean} Is string?
 * @memberof module:type
 */
function isString(obj) {
    return typeof obj === 'string' || obj instanceof String;
}

module.exports = isString;


/***/ }),

/***/ "./node_modules/tui-code-snippet/type/isUndefined.js":
/*!***********************************************************!*\
  !*** ./node_modules/tui-code-snippet/type/isUndefined.js ***!
  \***********************************************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

"use strict";
/**
 * @fileoverview Check whether the given variable is undefined or not.
 * @author NHN FE Development Lab <dl_javascript@nhn.com>
 */



/**
 * Check whether the given variable is undefined or not.
 * If the given variable is undefined, returns true.
 * @param {*} obj - Target for checking
 * @returns {boolean} Is undefined?
 * @memberof module:type
 */
function isUndefined(obj) {
    return obj === undefined; // eslint-disable-line no-undefined
}

module.exports = isUndefined;


/***/ }),

/***/ "./src/css/selectBox.css":
/*!*******************************!*\
  !*** ./src/css/selectBox.css ***!
  \*******************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

// extracted by mini-css-extract-plugin

/***/ }),

/***/ "./src/js/constants.js":
/*!*****************************!*\
  !*** ./src/js/constants.js ***!
  \*****************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports, __webpack_require__(/*! tui-code-snippet/collection/forEachOwnProperties */ "./node_modules/tui-code-snippet/collection/forEachOwnProperties.js")], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports, _forEachOwnProperties) {
  "use strict";

  _exports.__esModule = true;
  _exports.cls = void 0;
  _forEachOwnProperties = _interopRequireDefault(_forEachOwnProperties);

  function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

  /**
   * @fileoverview The static values
   * @author NHN. FE dev team.<dl_javascript@nhn.com>
   */
  var CSS_PREFIX = 'tui-select-box';
  var classNames = {
    SELECT_BOX: '',
    ITEM: 'item',
    ITEM_GROUP: 'item-group',
    ITEM_GROUP_LABEL: 'item-group-label',
    DROPDOWN: 'dropdown',
    INPUT: 'input',
    PLACEHOLDER: 'placeholder',
    ICON: 'icon',
    OPEN: 'open',
    HIDDEN: 'hidden',
    DISABLED: 'disabled',
    SELECTED: 'selected',
    HIGHLIGHT: 'highlight'
  };

  var cls = function () {
    (0, _forEachOwnProperties["default"])(classNames, function (value, key) {
      if (value) {
        classNames[key] = CSS_PREFIX + "-" + value;
      } else {
        classNames[key] = CSS_PREFIX;
      }
    });
    return classNames;
  }();

  _exports.cls = cls;
});

/***/ }),

/***/ "./src/js/dropdown.js":
/*!****************************!*\
  !*** ./src/js/dropdown.js ***!
  \****************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports, __webpack_require__(/*! tui-code-snippet/collection/forEachArray */ "./node_modules/tui-code-snippet/collection/forEachArray.js"), __webpack_require__(/*! tui-code-snippet/type/isExisty */ "./node_modules/tui-code-snippet/type/isExisty.js"), __webpack_require__(/*! tui-code-snippet/type/isNumber */ "./node_modules/tui-code-snippet/type/isNumber.js"), __webpack_require__(/*! tui-code-snippet/domUtil/addClass */ "./node_modules/tui-code-snippet/domUtil/addClass.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeClass */ "./node_modules/tui-code-snippet/domUtil/removeClass.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeElement */ "./node_modules/tui-code-snippet/domUtil/removeElement.js"), __webpack_require__(/*! ./utils */ "./src/js/utils.js"), __webpack_require__(/*! ./constants */ "./src/js/constants.js"), __webpack_require__(/*! ./itemGroup */ "./src/js/itemGroup.js"), __webpack_require__(/*! ./item */ "./src/js/item.js")], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports, _forEachArray, _isExisty, _isNumber, _addClass, _removeClass, _removeElement, _utils, _constants, _itemGroup, _item) {
  "use strict";

  _exports.__esModule = true;
  _exports["default"] = void 0;
  _forEachArray = _interopRequireDefault(_forEachArray);
  _isExisty = _interopRequireDefault(_isExisty);
  _isNumber = _interopRequireDefault(_isNumber);
  _addClass = _interopRequireDefault(_addClass);
  _removeClass = _interopRequireDefault(_removeClass);
  _removeElement = _interopRequireDefault(_removeElement);
  _itemGroup = _interopRequireDefault(_itemGroup);
  _item = _interopRequireDefault(_item);

  function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

  function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

  function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(source, true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(source).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

  function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

  /**
   * @class
   * @ignore
   * @param {object} options - options
   *   @param {string} [options.placeholder] - placeholder for an input
   *   @param {array<itemData|itemGroupData>} options.data - data for ItemGroups and Items
   *   @param {boolean} [options.disabled=false] - whether a dropdown should be disabled or not
   */
  var Dropdown =
  /*#__PURE__*/
  function () {
    function Dropdown(_ref) {
      var placeholder = _ref.placeholder,
          data = _ref.data,
          _ref$disabled = _ref.disabled,
          disabled = _ref$disabled === void 0 ? false : _ref$disabled;

      /**
       * @type {HTMLElement}
       * @private
       */
      this.el = (0, _utils.createElement)('ul', '', {
        className: _constants.cls.DROPDOWN + " " + _constants.cls.HIDDEN
      });
      /**
       * @type {HTMLElement}
       * @private
       */

      this.nativeEl = (0, _utils.createElement)('select', '', {
        className: _constants.cls.HIDDEN,
        tabIndex: -1
      });
      /**
       * Items and ItemGroups
       * @type {Array.<Item|ItemGroup>}
       * @private
       */

      this.items = [];
      /**
       * the number of Item
       * @type {number}
       * @private
       */

      this.itemLength = 0;
      /**
       * @type {Item}
       * @private
       */

      this.selectedItem = null;
      /**
       * @type {Item}
       * @private
       */

      this.highlightedItem = null;
      this.initialize(data, disabled, placeholder);
    }
    /**
     * Create Items and ItemGroups and calculate the number of Items
     * @return {array<Item|ItemGroup>}
     * @private
     */


    var _proto = Dropdown.prototype;

    _proto.initializeItems = function initializeItems(data) {
      var _this = this;

      var item;
      var itemIndex = 0;
      var itemGroupIndex = 0;
      data.forEach(function (datum) {
        if (datum.data) {
          item = new _itemGroup["default"](_objectSpread({
            index: itemIndex,
            itemGroupIndex: itemGroupIndex
          }, datum));
          itemIndex += datum.data.length - 1;
          itemGroupIndex += 1;
        } else {
          item = new _item["default"](_objectSpread({
            index: itemIndex
          }, datum));
        }

        _this.items.push(item);

        item.appendToContainer(_this.el, _this.nativeEl);
        itemIndex += 1;
      });
      this.itemLength = itemIndex;
    }
    /**
     * Initialize
     * @private
     */
    ;

    _proto.initialize = function initialize(data, disabled, placeholder) {
      var _this2 = this;

      if (placeholder) {
        (0, _utils.createElement)('option', '', {
          label: placeholder,
          value: ''
        }, this.nativeEl);
      }

      this.initializeItems(data);
      this.iterateItems(function (item) {
        if (!_this2.selectedItem && item.isSelected()) {
          _this2.selectedItem = item;
        } else if (_this2.selectedItem && item.isSelected()) {
          item.deselect();
        }
      });

      if (disabled) {
        this.disable();
      }
    }
    /**
     * Execute a function while iterating items
     * @param {function} callback - function to execute
     * @param  {...any} args - arguments
     * @private
     */
    ;

    _proto.iterateItems = function iterateItems(callback) {
      var _this3 = this;

      for (var _len = arguments.length, args = new Array(_len > 1 ? _len - 1 : 0), _key = 1; _key < _len; _key++) {
        args[_key - 1] = arguments[_key];
      }

      var index = 0;
      (0, _forEachArray["default"])(this.items, function (item) {
        var result = true;

        if (item instanceof _itemGroup["default"]) {
          (0, _forEachArray["default"])(item.getItems(), function (itemInGroup) {
            result = callback.apply(_this3, [itemInGroup, index].concat(args)) || false;
            index += 1;
            return result;
          });
          return result;
        }

        result = callback.apply(_this3, [item, index].concat(args));
        index += 1;
        return result;
      });
    }
    /**
     * Open a dropdown list
     */
    ;

    _proto.open = function open() {
      (0, _removeClass["default"])(this.el, _constants.cls.HIDDEN);
      var highlightedItem = !this.selectedItem || this.selectedItem.isDisabled() ? this.getItems(function (item) {
        return !item.isDisabled();
      })[0] : this.selectedItem;
      this.highlight(highlightedItem);
    }
    /**
     * Close a dropdown list
     */
    ;

    _proto.close = function close() {
      (0, _addClass["default"])(this.el, _constants.cls.HIDDEN);
      this.dehighlight();
    }
    /**
     * Disable an dropdown
     */
    ;

    _proto.disable = function disable() {
      this.nativeEl.disabled = true;
      (0, _addClass["default"])(this.el, _constants.cls.DISABLED);
    }
    /**
     * Enable an dropdown
     */
    ;

    _proto.enable = function enable() {
      this.nativeEl.disabled = false;
      (0, _removeClass["default"])(this.el, _constants.cls.DISABLED);
    }
    /**
     * Select an Item
     * @param {string|number|Item} value - if string, find an Item by its value. if number, find an Item by its index.
     * @return {Item} result of selection
     */
    ;

    _proto.select = function select(value) {
      var selectedItem = value instanceof _item["default"] ? value : this.getItem(value);
      this.deselect();

      if (!selectedItem || selectedItem && selectedItem.isDisabled()) {
        return null;
      }

      selectedItem.select();
      this.selectedItem = selectedItem;
      return selectedItem;
    }
    /**
     * Deselect an Item
     */
    ;

    _proto.deselect = function deselect() {
      if (this.selectedItem) {
        this.selectedItem.deselect();
        this.selectedItem = null;
      }
    }
    /**
     * Highlight an Item
     * @param {number|string|Item} value - if string, find an Item by its value. if number, find an Item by its index.
     */
    ;

    _proto.highlight = function highlight(value) {
      var highlightedItem;

      if (value instanceof _item["default"]) {
        highlightedItem = value;
      } else if ((0, _isExisty["default"])(value)) {
        highlightedItem = this.getItem(value);
      }

      if (highlightedItem && highlightedItem !== this.highlightedItem) {
        this.dehighlight();
        highlightedItem.highlight();
        this.highlightedItem = highlightedItem;
      }
    }
    /**
     * Dehighlight an Item
     */
    ;

    _proto.dehighlight = function dehighlight() {
      if (this.highlightedItem) {
        this.highlightedItem.dehighlight();
        this.highlightedItem = null;
      }
    }
    /**
     * Move a highlighted Item
     * @param {number} direction - direction to move
     */
    ;

    _proto.moveHighlightedItem = function moveHighlightedItem(direction) {
      var highlightedItem = this.getHighlightedItem();
      var items = this.getItems();
      var index = items.indexOf(highlightedItem);

      if (index > -1) {
        index += direction;

        for (; index < items.length && index >= 0; index += direction) {
          if (!items[index].isDisabled()) {
            this.highlight(items[index]);
            break;
          }
        }
      }
    }
    /**
     * Get all Items that pass the test implemented by the provided function
     * If filter function is not passed, it returns all Items
     * @param {function} callback - callback function to filter items
     * @param {number} number - the number of items to find. -1 means all items.
     * @return {array<Item>}
     */
    ;

    _proto.getItems = function getItems(callback, number) {
      if (callback === void 0) {
        callback = function callback() {
          return true;
        };
      }

      if (number === void 0) {
        number = -1;
      }

      var items = [];
      this.iterateItems(function (item) {
        if (callback(item)) {
          items.push(item);
          number -= 1;
          return number !== 0;
        }

        return true;
      });
      return items;
    }
    /**
     * Get an Item by its index or value
     * @param {number|string} value - if string, the Item's value. if number, the Item's index.
     * @return {Item}
     */
    ;

    _proto.getItem = function getItem(value) {
      var isValidItem = (0, _isNumber["default"])(value) ? function (comparedItem) {
        return comparedItem.getIndex() === value;
      } : function (comparedItem) {
        return comparedItem.getValue() === value;
      };
      return this.getItems(isValidItem, 1)[0];
    }
    /**
     * Get all ItemGroups that pass the test implemented by the provided function
     * If filter function is not passed, it returns all ItemGroups
     * @param {function} callback - callback function to filter item groups
     * @param {number} number - the number of item groups to find. -1 means all item groups.
     * @return {array<ItemGroup>}
     */
    ;

    _proto.getItemGroups = function getItemGroups(callback, number) {
      if (callback === void 0) {
        callback = function callback() {
          return true;
        };
      }

      if (number === void 0) {
        number = -1;
      }

      var itemGroups = [];
      (0, _forEachArray["default"])(this.items, function (itemGroup) {
        if (itemGroup instanceof _itemGroup["default"] && callback(itemGroup)) {
          itemGroups.push(itemGroup);
          number -= 1;
          return number !== 0;
        }

        return true;
      });
      return itemGroups;
    }
    /**
     * Get an ItemGroup by its index
     * @param {number} index - groupIndex of the ItemGroup
     * @return {ItemGroup}
     */
    ;

    _proto.getItemGroup = function getItemGroup(index) {
      return this.getItemGroups(function (itemGroup) {
        return itemGroup.getIndex() === index;
      }, 1)[0];
    }
    /**
     * Return the number of Items
     * @return {number}
     */
    ;

    _proto.getItemLength = function getItemLength() {
      return this.itemLength;
    }
    /**
     * Return the selected Item
     * @return {Item}
     */
    ;

    _proto.getSelectedItem = function getSelectedItem() {
      return this.selectedItem;
    }
    /**
     * Return the highlighted Item
     * @return {Item}
     */
    ;

    _proto.getHighlightedItem = function getHighlightedItem() {
      return this.highlightedItem;
    }
    /**
     * Append the element and native element to the container
     * @param {HTMLElement} container - container element
     */
    ;

    _proto.appendToContainer = function appendToContainer(container) {
      container.appendChild(this.el);
      container.appendChild(this.nativeEl);
    }
    /**
     * Destory a dropdown
     */
    ;

    _proto.destroy = function destroy() {
      this.items.forEach(function (item) {
        return item.destroy();
      });
      (0, _removeElement["default"])(this.el);
      (0, _removeElement["default"])(this.nativeEl);
      this.el = this.nativeEl = this.items = this.selectedItem = this.highlightedItem = null;
    };

    return Dropdown;
  }();

  _exports["default"] = Dropdown;
});

/***/ }),

/***/ "./src/js/index.js":
/*!*************************!*\
  !*** ./src/js/index.js ***!
  \*************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports, __webpack_require__(/*! ./selectBox */ "./src/js/selectBox.js"), __webpack_require__(/*! ../css/selectBox.css */ "./src/css/selectBox.css")], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports, _selectBox, _selectBox2) {
  "use strict";

  _exports.__esModule = true;
  _exports["default"] = void 0;
  _selectBox = _interopRequireDefault(_selectBox);

  function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

  /**
   * @fileoverview
   * @author NHN FE Development Lab <dl_javascript@nhn.com>
   */
  var _default = _selectBox["default"];
  _exports["default"] = _default;
});

/***/ }),

/***/ "./src/js/input.js":
/*!*************************!*\
  !*** ./src/js/input.js ***!
  \*************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports, __webpack_require__(/*! tui-code-snippet/domUtil/addClass */ "./node_modules/tui-code-snippet/domUtil/addClass.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeClass */ "./node_modules/tui-code-snippet/domUtil/removeClass.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeElement */ "./node_modules/tui-code-snippet/domUtil/removeElement.js"), __webpack_require__(/*! ./utils */ "./src/js/utils.js"), __webpack_require__(/*! ./constants */ "./src/js/constants.js")], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports, _addClass, _removeClass, _removeElement, _utils, _constants) {
  "use strict";

  _exports.__esModule = true;
  _exports["default"] = void 0;
  _addClass = _interopRequireDefault(_addClass);
  _removeClass = _interopRequireDefault(_removeClass);
  _removeElement = _interopRequireDefault(_removeElement);

  function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

  /**
   * @fileoverview Input
   * @author NHN FE Development Lab <dl_javascript@nhn.com>
   */

  /**
   * @class
   * @ignore
   * @param {object} options - options
   *   @param {string} [options.placeholder] - placeholder for a select box
   *   @param {string} [options.disabled] - whether an input should be disabled or not
   *   @param {boolean} [options.showIcon] - whether an arrow icon in the input should be shown
   */
  var Input =
  /*#__PURE__*/
  function () {
    function Input(_ref) {
      var placeholder = _ref.placeholder,
          disabled = _ref.disabled,
          showIcon = _ref.showIcon;

      /**
       * text for a placeholder
       * @type {string}
       * @private
       */
      this.placeholderText = placeholder;
      /**
       * @type {HTMLElement}
       * @private
       */

      this.el = (0, _utils.createElement)('div', '', {
        className: _constants.cls.INPUT,
        tabIndex: 0
      });
      /**
       * @type {HTMLElement}
       * @private
       */

      this.placeholderEl = (0, _utils.createElement)('p', this.placeholderText, {
        className: _constants.cls.PLACEHOLDER
      }, this.el);
      this.initialize(disabled, showIcon);
    }
    /**
     * Initialize
     * @private
     */


    var _proto = Input.prototype;

    _proto.initialize = function initialize(disabled, showIcon) {
      if (showIcon) {
        (0, _utils.createElement)('span', 'select', {
          className: _constants.cls.ICON
        }, this.el);
      } else {
        this.placeholderEl.width = '100%';
      }

      if (disabled) {
        this.disable();
      }
    }
    /**
     * Disable an input
     */
    ;

    _proto.disable = function disable() {
      (0, _addClass["default"])(this.el, _constants.cls.DISABLED);
    }
    /**
     * Enable an input
     */
    ;

    _proto.enable = function enable() {
      (0, _removeClass["default"])(this.el, _constants.cls.DISABLED);
    }
    /**
     * Open an input
     */
    ;

    _proto.open = function open() {
      (0, _addClass["default"])(this.el, _constants.cls.OPEN);
    }
    /**
     * Close an input
     */
    ;

    _proto.close = function close() {
      (0, _removeClass["default"])(this.el, _constants.cls.OPEN);
    }
    /**
     * Focus
     */
    ;

    _proto.focus = function focus() {
      this.el.focus();
    }
    /**
     * Change the text in the placeholder
     * @param {Item} item - selected Item
     */
    ;

    _proto.changeText = function changeText(item) {
      if (item) {
        this.placeholderEl.innerText = item.getLabel();
      } else {
        this.placeholderEl.innerText = this.placeholderText;
      }
    }
    /**
     * Append the element to the container
     * @param {HTMLElement} container - container element
     */
    ;

    _proto.appendToContainer = function appendToContainer(container) {
      container.appendChild(this.el);
    }
    /**
     * Destroy an input
     */
    ;

    _proto.destroy = function destroy() {
      (0, _removeElement["default"])(this.el);
      this.el = this.placeholderEl = null;
    };

    return Input;
  }();

  _exports["default"] = Input;
});

/***/ }),

/***/ "./src/js/item.js":
/*!************************!*\
  !*** ./src/js/item.js ***!
  \************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports, __webpack_require__(/*! tui-code-snippet/domUtil/addClass */ "./node_modules/tui-code-snippet/domUtil/addClass.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeClass */ "./node_modules/tui-code-snippet/domUtil/removeClass.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeElement */ "./node_modules/tui-code-snippet/domUtil/removeElement.js"), __webpack_require__(/*! ./utils */ "./src/js/utils.js"), __webpack_require__(/*! ./constants */ "./src/js/constants.js")], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports, _addClass, _removeClass, _removeElement, _utils, _constants) {
  "use strict";

  _exports.__esModule = true;
  _exports["default"] = void 0;
  _addClass = _interopRequireDefault(_addClass);
  _removeClass = _interopRequireDefault(_removeClass);
  _removeElement = _interopRequireDefault(_removeElement);

  function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

  /**
   * @fileoverview Item
   * @author NHN FE Development Lab <dl_javascript@nhn.com>
   */

  /**
   * @class
   * @description
   * An item.
   * You can get Item by {@link SelectBox#getItem SelectBox.getItem()} and {@link SelectBox#getItems SelectBox.getItems()}.
   */
  var Item =
  /*#__PURE__*/
  function () {
    /**
     * @hideconstructor
     * @param {object} options - options
     *   @param {string} [options.label] - label to be displayed in the drop-down list
     *   @param {string} options.value - value of an item
     *   @param {boolean} [options.disabled=false] - whether an Item should be disabled or not
     *   @param {boolean} [options.selected=false] - whether an Item should be pre-selected or not
     *   @param {number} options.index - Item's index
     */
    function Item(_ref) {
      var value = _ref.value,
          label = _ref.label,
          disabled = _ref.disabled,
          selected = _ref.selected,
          index = _ref.index;

      /**
       * value of an item
       * @type {string}
       * @private
       */
      this.value = "" + value;
      /**
       * label to be displayed in the drop-down list
       * if label is an empty string, it should be same as its value
       * @type {string}
       * @private
       */

      this.label = label || this.value;
      /**
       * @type {number}
       * @private
       */

      this.index = index;
      /**
       * whether an ItemGroup of the Item is disabled or not
       * @type {boolean}
       * @private
       */

      this.itemGroupDisabled = false;
      /**
       * whether an Item is disabled or not
       * @type {boolean}
       * @private
       */

      this.itemDisabled = false;
      /**
       * @type {boolean}
       * @private
       */

      this.selected = false;
      /**
       * <li> element for a custom dropdown item
       * @type {HTMLElement}
       * @private
       */

      this.el = (0, _utils.createElement)('li', this.label, {
        className: _constants.cls.ITEM,
        tabIndex: -1,
        'data-value': this.value,
        'data-index': this.index
      });
      /**
       * <option> element for a select element
       * @type {HTMLElement}
       * @private
       */

      this.nativeEl = (0, _utils.createElement)('option', '', {
        value: this.value,
        label: this.label
      });
      this.initialize(disabled, selected);
    }
    /**
     * Initialize
     * @private
     */


    var _proto = Item.prototype;

    _proto.initialize = function initialize(disabled, selected) {
      if (selected) {
        this.select();
      }

      if (disabled) {
        this.disable();
      }
    }
    /**
     * Make an Item disable
     * @private
     */
    ;

    _proto.makeDisable = function makeDisable() {
      this.nativeEl.disabled = true;
      (0, _addClass["default"])(this.el, _constants.cls.DISABLED);
    }
    /**
     * Make an Item enable
     * @private
     */
    ;

    _proto.makeEnable = function makeEnable() {
      this.nativeEl.disabled = false;
      (0, _removeClass["default"])(this.el, _constants.cls.DISABLED);
    }
    /**
     * Disable an Item due to an ItemGroup
     * @ignore
     */
    ;

    _proto.disableItemGroup = function disableItemGroup() {
      this.itemGroupDisabled = true;
      this.makeDisable();
    }
    /**
     * Enable an Item due to an ItemGroup
     * @ignore
     */
    ;

    _proto.enableItemGroup = function enableItemGroup() {
      this.itemGroupDisabled = false;

      if (!this.isDisabled()) {
        this.makeEnable();
      }
    }
    /**
     * Disable an Item
     * @ignore
     */
    ;

    _proto.disable = function disable() {
      this.itemDisabled = true;
      this.makeDisable();
    }
    /**
     * Enable an Item
     * @ignore
     */
    ;

    _proto.enable = function enable() {
      this.itemDisabled = false;

      if (!this.isDisabled()) {
        this.makeEnable();
      }
    }
    /**
     * Select an Item
     * @ignore
     */
    ;

    _proto.select = function select() {
      if (!this.isDisabled()) {
        this.selected = this.nativeEl.selected = true;
        (0, _addClass["default"])(this.el, _constants.cls.SELECTED);
      }
    }
    /**
     * Deselect an Item
     * @ignore
     */
    ;

    _proto.deselect = function deselect() {
      this.selected = this.nativeEl.selected = false;
      (0, _removeClass["default"])(this.el, _constants.cls.SELECTED);
    }
    /**
     * Highlight an Item
     * @ignore
     */
    ;

    _proto.highlight = function highlight() {
      if (!this.isDisabled()) {
        (0, _addClass["default"])(this.el, _constants.cls.HIGHLIGHT);
        this.el.focus();
      }
    }
    /**
     * Remove a highlight from an Item
     * @ignore
     */
    ;

    _proto.dehighlight = function dehighlight() {
      (0, _removeClass["default"])(this.el, _constants.cls.HIGHLIGHT);
      this.el.blur();
    }
    /**
     * Return an item's value.
     * @return {string}
     */
    ;

    _proto.getValue = function getValue() {
      return this.value;
    }
    /**
     * Return an item's label.
     * @return {string}
     */
    ;

    _proto.getLabel = function getLabel() {
      return this.label;
    }
    /**
     * Return an item's index.
     * @return {number}
     */
    ;

    _proto.getIndex = function getIndex() {
      return this.index;
    }
    /**
     * Return whether an item is selected or not.
     * @return {boolean}
     */
    ;

    _proto.isSelected = function isSelected() {
      return this.selected;
    }
    /**
     * Return whether an item is disabled or not.
     * The result is true if any of the items and item groups are disabled.
     * @return {boolean}
     */
    ;

    _proto.isDisabled = function isDisabled() {
      return this.itemDisabled || this.itemGroupDisabled;
    }
    /**
     * Append the element and native element to the containers
     * @param {HTMLElement} container - container element
     * @param {HTMLElement} nativeContainer - native container element
     * @ignore
     */
    ;

    _proto.appendToContainer = function appendToContainer(container, nativeContainer) {
      container.appendChild(this.el);
      nativeContainer.appendChild(this.nativeEl);
    }
    /**
     * Destroy an Item
     * @ignore
     */
    ;

    _proto.destroy = function destroy() {
      (0, _removeElement["default"])(this.el);
      (0, _removeElement["default"])(this.nativeEl);
      this.el = this.nativeEl = null;
    };

    return Item;
  }();

  _exports["default"] = Item;
});

/***/ }),

/***/ "./src/js/itemGroup.js":
/*!*****************************!*\
  !*** ./src/js/itemGroup.js ***!
  \*****************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports, __webpack_require__(/*! tui-code-snippet/domUtil/addClass */ "./node_modules/tui-code-snippet/domUtil/addClass.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeClass */ "./node_modules/tui-code-snippet/domUtil/removeClass.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeElement */ "./node_modules/tui-code-snippet/domUtil/removeElement.js"), __webpack_require__(/*! ./utils */ "./src/js/utils.js"), __webpack_require__(/*! ./constants */ "./src/js/constants.js"), __webpack_require__(/*! ./item */ "./src/js/item.js")], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports, _addClass, _removeClass, _removeElement, _utils, _constants, _item) {
  "use strict";

  _exports.__esModule = true;
  _exports["default"] = void 0;
  _addClass = _interopRequireDefault(_addClass);
  _removeClass = _interopRequireDefault(_removeClass);
  _removeElement = _interopRequireDefault(_removeElement);
  _item = _interopRequireDefault(_item);

  function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

  function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

  function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(source, true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(source).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

  function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

  /**
   * @class
   * @description
   * A group of items.
   * You can get ItemGroup by {@link SelectBox#getItemGroup SelectBox.getItemGroup()} and {@link SelectBox#getItemGroups SelectBox.getItemGroups()}.
   */
  var ItemGroup =
  /*#__PURE__*/
  function () {
    /**
     * @hideconstructor
     * @param {object} options - options
     *   @param {string} [options.label] - label to be displayed in the dropdown list
     *   @param {array<itemData>} options.data - data for Items to be included in the ItemGroup
     *   @param {boolean} [options.disabled=false] - whether an ItemGroup should be disabled or not
     *   @param {number} options.index - index of the first Item in the ItemGroup
     *   @param {number} options.itemGroupIndex - index of the ItemGroup
     */
    function ItemGroup(_ref) {
      var _ref$label = _ref.label,
          label = _ref$label === void 0 ? '' : _ref$label,
          data = _ref.data,
          _ref$disabled = _ref.disabled,
          disabled = _ref$disabled === void 0 ? false : _ref$disabled,
          index = _ref.index,
          itemGroupIndex = _ref.itemGroupIndex;

      /**
       * @type {HTMLElement}
       * @private
       */
      this.el = (0, _utils.createElement)('li', '', {
        'data-group-index': itemGroupIndex
      });
      /**
       * @type {HTMLElement}
       * @private
       */

      this.labelEl = (0, _utils.createElement)('span', label, {
        className: _constants.cls.ITEM_GROUP_LABEL
      }, this.el);
      /**
       * @type {HTMLElement}
       * @private
       */

      this.itemContainerEl = (0, _utils.createElement)('ul', '', {
        className: _constants.cls.ITEM_GROUP
      }, this.el);
      /**
       * @type {HTMLElement}
       * @private
       */

      this.nativeEl = (0, _utils.createElement)('optgroup', label);
      /**
       * @type {array<Item>}
       * @private
       */

      this.items = this.createItems(data, index);
      /**
       * @type {number}
       * @private
       */

      this.index = itemGroupIndex;
      /**
       * @type {string}
       * @private
       */

      this.label = label;
      /**
       * whether an ItemGroup is disabled or not
       * @type {boolean}
       * @private
       */

      this.disabled = false;
      this.initialize(disabled);
    }
    /**
     * Create Items to be included in the ItemGroup
     * @return {array<Item>}
     * @private
     */


    var _proto = ItemGroup.prototype;

    _proto.createItems = function createItems(data, index) {
      var _this = this;

      return data.map(function (datum, itemIndex) {
        var item = new _item["default"](_objectSpread({
          index: index + itemIndex
        }, datum));
        item.appendToContainer(_this.itemContainerEl, _this.nativeEl);
        return item;
      });
    }
    /**
     * Initialize
     * @private
     */
    ;

    _proto.initialize = function initialize(disabled) {
      if (disabled) {
        this.disable();
      }
    }
    /**
     * Disable an ItemGroup
     * @ignore
     */
    ;

    _proto.disable = function disable() {
      this.disabled = this.nativeEl.disabled = true;
      (0, _addClass["default"])(this.labelEl, _constants.cls.DISABLED);
      this.items.forEach(function (item) {
        return item.disableItemGroup();
      });
    }
    /**
     * Enable an ItemGroup
     * @ignore
     */
    ;

    _proto.enable = function enable() {
      this.disabled = this.nativeEl.disabled = false;
      (0, _removeClass["default"])(this.labelEl, _constants.cls.DISABLED);
      this.items.forEach(function (item) {
        return item.enableItemGroup();
      });
    }
    /**
     * Get {@link Item items} in the item group.
     * @return {array<Item>}
     * @example
     * const items = itemGroup.getItems();
     * console.log(items[0]); // first item in the item group
     * console.log(items.length); // the number of items in the item group
     */
    ;

    _proto.getItems = function getItems() {
      return this.items;
    }
    /**
     * Return an item group's index.
     * @return {number}
     */
    ;

    _proto.getIndex = function getIndex() {
      return this.index;
    }
    /**
     * Return an item group's label.
     * @return {string}
     */
    ;

    _proto.getLabel = function getLabel() {
      return this.label;
    }
    /**
     * Return whether an ItemGroup is disabled or not.
     * @return {boolean}
     */
    ;

    _proto.isDisabled = function isDisabled() {
      return this.disabled;
    }
    /**
     * Append the element and native element to the containers
     * @param {HTMLElement} container - container element
     * @param {HTMLElement} nativeContainer - native container element
     * @ignore
     */
    ;

    _proto.appendToContainer = function appendToContainer(container, nativeContainer) {
      container.appendChild(this.el);
      nativeContainer.appendChild(this.nativeEl);
    }
    /**
     * Destory an ItemGroup
     * @ignore
     */
    ;

    _proto.destroy = function destroy() {
      this.items.forEach(function (item) {
        return item.destroy();
      });
      (0, _removeElement["default"])(this.el);
      (0, _removeElement["default"])(this.nativeEl);
      this.el = this.labelEl = this.itemContainerEl = this.nativeEl = this.items = null;
    };

    return ItemGroup;
  }();

  _exports["default"] = ItemGroup;
});

/***/ }),

/***/ "./src/js/keyEventUtils.js":
/*!*********************************!*\
  !*** ./src/js/keyEventUtils.js ***!
  \*********************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports) {
  "use strict";

  _exports.__esModule = true;
  _exports.identifyKey = void 0;

  /**
   * @fileoverview Utility functions related to key events
   * @author NHN. FE dev team.<dl_javascript@nhn.com>
   */
  var keyCodeMap = {
    38: 'arrowUp',
    40: 'arrowDown',
    32: 'space',
    13: 'enter',
    27: 'escape',
    61: 'tab'
  };
  var keyMap = {
    ArrowUp: 'arrowUp',
    Up: 'arrowUp',
    ArrowDown: 'arrowDown',
    Down: 'arrowDown',
    ' ': 'space',
    Spacebar: 'space',
    Enter: 'enter',
    Escape: 'escape',
    Esc: 'escape',
    Tab: 'tab'
  };
  /**
   * Identify the key (polyfill for IE)
   * @param {string} ev - keyboard event
   * @return {string} - key
   */

  var identifyKey = function identifyKey(ev) {
    var key = ev.key,
        keyCode = ev.keyCode;

    if (key) {
      return keyMap[key] || key;
    }

    return keyCodeMap[keyCode] || keyCode;
  };

  _exports.identifyKey = identifyKey;
});

/***/ }),

/***/ "./src/js/selectBox.js":
/*!*****************************!*\
  !*** ./src/js/selectBox.js ***!
  \*****************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports, __webpack_require__(/*! tui-code-snippet/customEvents/customEvents */ "./node_modules/tui-code-snippet/customEvents/customEvents.js"), __webpack_require__(/*! tui-code-snippet/domEvent/on */ "./node_modules/tui-code-snippet/domEvent/on.js"), __webpack_require__(/*! tui-code-snippet/domEvent/off */ "./node_modules/tui-code-snippet/domEvent/off.js"), __webpack_require__(/*! tui-code-snippet/domEvent/preventDefault */ "./node_modules/tui-code-snippet/domEvent/preventDefault.js"), __webpack_require__(/*! tui-code-snippet/domEvent/getTarget */ "./node_modules/tui-code-snippet/domEvent/getTarget.js"), __webpack_require__(/*! tui-code-snippet/domUtil/closest */ "./node_modules/tui-code-snippet/domUtil/closest.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeElement */ "./node_modules/tui-code-snippet/domUtil/removeElement.js"), __webpack_require__(/*! tui-code-snippet/type/isObject */ "./node_modules/tui-code-snippet/type/isObject.js"), __webpack_require__(/*! tui-code-snippet/type/isExisty */ "./node_modules/tui-code-snippet/type/isExisty.js"), __webpack_require__(/*! tui-code-snippet/type/isHTMLNode */ "./node_modules/tui-code-snippet/type/isHTMLNode.js"), __webpack_require__(/*! tui-code-snippet/request/sendHostname */ "./node_modules/tui-code-snippet/request/sendHostname.js"), __webpack_require__(/*! ./utils */ "./src/js/utils.js"), __webpack_require__(/*! ./keyEventUtils */ "./src/js/keyEventUtils.js"), __webpack_require__(/*! ./constants */ "./src/js/constants.js"), __webpack_require__(/*! ./input */ "./src/js/input.js"), __webpack_require__(/*! ./dropdown */ "./src/js/dropdown.js"), __webpack_require__(/*! ./itemGroup */ "./src/js/itemGroup.js"), __webpack_require__(/*! ./item */ "./src/js/item.js"), __webpack_require__(/*! ./theme */ "./src/js/theme.js")], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports, _customEvents, _on, _off, _preventDefault, _getTarget, _closest, _removeElement, _isObject, _isExisty, _isHTMLNode, _sendHostname, _utils, _keyEventUtils, _constants, _input, _dropdown, _itemGroup, _item, _theme) {
  "use strict";

  _exports.__esModule = true;
  _exports["default"] = void 0;
  _customEvents = _interopRequireDefault(_customEvents);
  _on = _interopRequireDefault(_on);
  _off = _interopRequireDefault(_off);
  _preventDefault = _interopRequireDefault(_preventDefault);
  _getTarget = _interopRequireDefault(_getTarget);
  _closest = _interopRequireDefault(_closest);
  _removeElement = _interopRequireDefault(_removeElement);
  _isObject = _interopRequireDefault(_isObject);
  _isExisty = _interopRequireDefault(_isExisty);
  _isHTMLNode = _interopRequireDefault(_isHTMLNode);
  _sendHostname = _interopRequireDefault(_sendHostname);
  _input = _interopRequireDefault(_input);
  _dropdown = _interopRequireDefault(_dropdown);
  _itemGroup = _interopRequireDefault(_itemGroup);
  _item = _interopRequireDefault(_item);
  _theme = _interopRequireDefault(_theme);

  function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

  /**
   * @fileoverview SelectBox
   * @author NHN FE Development Lab <dl_javascript@nhn.com>
   */

  /**
   * @class
   * @param {HTMLElement|string} container - container element or selector
   * @mixes CustomEvents
   * @param {object} options
   *   @param {array<itemData|itemGroupData>} options.data - array of {@link itemData} and {@link itemGroupData}
   *   @param {string} [options.placeholder] - placeholder for an input
   *   @param {boolean} [options.disabled] - whether an Item should be disabled or not
   *   @param {boolean} [options.autofocus] - whether a selectbox should get focus when the select box appends to the container
   *   @param {boolean} [options.autoclose] - whether a selectbox should close after selection
   *   @param {boolean} [options.showIcon] - whether an arrow icon in the input should be shown
   *   @param {object} [options.theme] - {@link themeConfig} for custom style
   *   @param {boolean} [options.usageStatistics] - whether send hostname to google analytics. If you don't want to send the hostname, please set to false.
   * @example
   * import SelectBox from '@toast-ui/select-box';
   * // or const SelectBox = require('@toast-ui/select-box');
   * // or const SelectBox = tui.SelectBox;
   *
   * const selectBox = new SelectBox('#select-box', {
   *   placeholder: 'Please select an option.',
   *   data: [
   *     {
   *       label: 'Fruits',
   *       data: [ { label: 'Apple', value: 'apple' }, { label: 'Banana', value: 'banana' } ]
   *     },
   *     { label: 'The quick brown fox jumps over the lazy dog.', value: 'none' },
   *     {
   *       label: 'Colors',
   *       data: [
   *         { label: 'Red', value: 'red' },
   *         { label: 'Yellow', value: 'yellow' },
   *         { label: 'Green', value: 'green', disabled: true },
   *         { label: 'Blue', value: 'blue', disabled: true },
   *         { label: 'Purple', value: 'purple' }
   *       ]
   *     }
   *   ],
   *   autofocus: true,
   *   showIcon: false,
   *   theme: {
   *     'common.border': '1px solid black',
   *     'common.color': 'black',
   *     'item.highlighted.background': 'yellow'
   *   }
   * });
   */

  /**
   * SelectBox provides some custom events: ({@link SelectBox#event-open open}, {@link SelectBox#event-close close}, {@link SelectBox#event-disable disable}, {@link SelectBox#event-enable enable}, {@link SelectBox#event-change change}).
   * You can bind event handlers by {@link https://nhn.github.io/tui.code-snippet/latest/CustomEvents#on selectBox.on(eventName, handler)} and unbind by {@link https://nhn.github.io/tui.code-snippet/latest/CustomEvents#off selectBox.off(eventName, handler)}.
   * Refer to the {@link https://nhn.github.io/tui.code-snippet/latest/CustomEvents CustomEvents} document at {@link https://github.com/nhn/tui.code-snippet tui-code-snippet} to know how to bind, and unbind custom events.
   * The example using custom events can be found {@link tutorial-example03-custom-events here}.
   * @typedef {class} CustomEvents
   * @example
   * // bind 'change' event
   * selectBox.on('change', ev => {
   *   console.log(`selected item is changed from ${ev.prev.getLabel()} to ${ev.curr.getLabel()}.`);
   * });
   *
   * // bind 'disable' and enable event
   * const print = ev => {
   *   let target = '';
   *   if (ev.target instanceof SelectBox) {
   *     target = 'Select box';
   *   } else {
   *     target = ev.target.getLabel();
   *   }
   *   console.log(`${target} is ${ev.type}.`);
   * }
   * selectBox.on({
   *   disable: print,
   *   enable: print
   * });
   *
   * // unbind change event
   * selectBox.off('change');
   *
   * // unbind disable event
   * selectBox.off(disable, print);
   *
   * // unbind all events
   * selectBox.off();
   */

  /**
   * Data of an {@link Item item}.
   * It is used for creating a {@link SelectBox}.
   * @typedef {object} itemData - data for {@link Item item}
   * @property {string} label - label to be displayed
   * @property {string} value - value of an item
   * @property {boolean} [disabled=false] - whether an item should be disabled or not
   * @property {boolean} [selected=false] - whether an item should be pre-selected or not
   * @example
   * const itemData = {
   *   label: 'disabled item',
   *   value: '0',
   *   disabled: true,
   *   selected: false
   * };
   */

  /**
   * Data of an {@link ItemGroup item group}.
   * It is used for creating a {@link SelectBox}.
   * ItemGroup supports only 1 level choices, so it does not work to add item groups in the item group.
   * The example using item groups can be found {@link tutorial-example01-basic here}.
   * @typedef {object} itemGroupData - data for {@link ItemGroup item group}
   * @property {string} label - label to be displayed
   * @property {array} data - {@link itemData data for item}
   * @property {boolean} [disabled=false] - whether an item group should be disabled or not
   * @example
   * const itemGroupData = {
   *   label: 'disabled items',
   *   data: [
   *     { label: 'disable', value: 'disable' },
   *     { label: 'none', value: '0' }
   *   ],
   *   disabled: true
   * };
   */
  var SelectBox =
  /*#__PURE__*/
  function () {
    function SelectBox(container, _ref) {
      var data = _ref.data,
          _ref$placeholder = _ref.placeholder,
          placeholder = _ref$placeholder === void 0 ? '' : _ref$placeholder,
          _ref$disabled = _ref.disabled,
          disabled = _ref$disabled === void 0 ? false : _ref$disabled,
          _ref$autofocus = _ref.autofocus,
          autofocus = _ref$autofocus === void 0 ? false : _ref$autofocus,
          _ref$autoclose = _ref.autoclose,
          autoclose = _ref$autoclose === void 0 ? true : _ref$autoclose,
          _ref$showIcon = _ref.showIcon,
          showIcon = _ref$showIcon === void 0 ? true : _ref$showIcon,
          theme = _ref.theme,
          _ref$usageStatistics = _ref.usageStatistics,
          usageStatistics = _ref$usageStatistics === void 0 ? true : _ref$usageStatistics;

      /**
       * @type {HTMLElement}
       * @private
       */
      this.el = (0, _utils.createElement)('div', '', {
        className: _constants.cls.SELECT_BOX
      });
      /**
       * @type {Input}
       * @private
       */

      this.input = new _input["default"]({
        placeholder: placeholder,
        disabled: disabled,
        showIcon: showIcon
      });
      /**
       * @type {Dropdown}
       * @private
       */

      this.dropdown = new _dropdown["default"]({
        placeholder: placeholder,
        disabled: disabled,
        data: data
      });
      /**
       * @type {boolean}
       * @private
       */

      this.opened = false;
      /**
       * @type {boolean}
       * @private
       */

      this.diabled = false;
      /**
       * @type {boolean}
       */

      this.autoclose = autoclose;
      /**
       * @type {Theme}
       * @private
       */

      this.theme = (0, _isObject["default"])(theme) ? new _theme["default"](theme, container) : null;
      this.initialize({
        placeholder: placeholder,
        disabled: disabled
      });
      this.appendToContainer(container);

      if (autofocus) {
        this.input.focus();
      }

      if (usageStatistics) {
        (0, _sendHostname["default"])('select-box', 'UA-129987462-1');
      }
    }
    /**
     * Append the select box element to the container
     * @param {HTMLElement|string} container - container element or selector
     * @private
     */


    var _proto = SelectBox.prototype;

    _proto.appendToContainer = function appendToContainer(container) {
      var containerEl = (0, _isHTMLNode["default"])(container) ? container : document.querySelector(container);
      containerEl.appendChild(this.el);
    }
    /**
     * Initialize
     * @param {object} options - options
     * @private
     */
    ;

    _proto.initialize = function initialize(options) {
      var selectedItem = this.getSelectedItem();

      if (selectedItem) {
        this.input.changeText(selectedItem);
      } else if (!options.placeholder) {
        this.select(0);
      }

      if (options.disabled) {
        this.disable();
      }

      this.bindEvents();
      this.input.appendToContainer(this.el);
      this.dropdown.appendToContainer(this.el);
    }
    /**
     * Bind events
     * @private
     */
    ;

    _proto.bindEvents = function bindEvents() {
      var _this = this;

      (0, _on["default"])(document, 'click', function (ev) {
        var target = (0, _getTarget["default"])(ev);

        if (!(0, _closest["default"])(target, "." + _constants.cls.SELECT_BOX) && _this.opened) {
          _this.close();
        }
      }, this);
      (0, _on["default"])(this.el, 'click', function (ev) {
        return _this.handleClick(ev, _constants.cls);
      });
      (0, _on["default"])(this.el, 'mouseover', function (ev) {
        return _this.handleMouseover(ev, _constants.cls);
      });
      (0, _on["default"])(this.el, 'keydown', function (ev) {
        return _this.handleKeydown(ev, _constants.cls);
      });
    }
    /**
     * Unbind events
     * @private
     */
    ;

    _proto.unbindEvents = function unbindEvents() {
      (0, _off["default"])(document, 'click');
      (0, _off["default"])(this.el, 'click mouseover keydown');
    }
    /**
     * Handle click events
     * @param {Event} ev - an event
     * @param {object} cls - cls
     * @private
     */
    ;

    _proto.handleClick = function handleClick(ev, _ref2) {
      var INPUT = _ref2.INPUT,
          ITEM = _ref2.ITEM;
      var target = (0, _getTarget["default"])(ev);
      var itemEl = (0, _closest["default"])(target, "." + ITEM);

      if (itemEl) {
        this.select(itemEl.getAttribute('data-value'));
      } else if ((0, _closest["default"])(target, "." + INPUT)) {
        this.toggle();
      }
    }
    /**
     * Handle mouseover events
     * @param {Event} ev - an event
     * @param {object} cls - cls
     * @private
     */
    ;

    _proto.handleMouseover = function handleMouseover(ev, _ref3) {
      var ITEM = _ref3.ITEM;

      if (this.checkMousemove(ev.clientX, ev.clientY)) {
        var target = (0, _getTarget["default"])(ev);
        var itemEl = (0, _closest["default"])(target, "." + ITEM);

        if (itemEl) {
          this.dropdown.highlight(itemEl.getAttribute('data-value'));
        }
      }
    }
    /**
     * Check if a pointer is moved
     * @param {number} x - mouseEvent.clientX
     * @param {number} y - mouseEvent.clientY
     * @return {boolean}
     * @private
     */
    ;

    _proto.checkMousemove = function checkMousemove(x, y) {
      if (this.prevX !== x || this.prevY !== y) {
        this.prevX = x;
        this.prevY = y;
        return true;
      }

      return false;
    }
    /**
     * Handle keydown events
     * @param {Event} ev - an event
     * @param {object} classNames - cls
     * @private
     */
    ;

    _proto.handleKeydown = function handleKeydown(ev, classNames) {
      var key = (0, _keyEventUtils.identifyKey)(ev);
      var closeKeys = ['tab', 'escape'];
      var activeKeys = ['arrowUp', 'arrowDown', 'space', 'enter'];

      if (closeKeys.indexOf(key) > -1 && this.opened) {
        this.close();

        if (key === 'escape') {
          this.input.focus();
        }
      } else if (activeKeys.indexOf(key) > -1) {
        (0, _preventDefault["default"])(ev);
        this.activateKeydown(ev, key, classNames);
      }
    }
    /**
     * Activate keydown events
     * @param {Event} ev - an event
     * @param {string} key - key pressed
     * @param {object} classNames - cls
     * @private
     */
    ;

    _proto.activateKeydown = function activateKeydown(ev, key, _ref4) {
      var ITEM = _ref4.ITEM,
          INPUT = _ref4.INPUT;
      var target = (0, _getTarget["default"])(ev);
      var itemEl = (0, _closest["default"])(target, "." + ITEM);

      if (key === 'escape' && this.opened) {
        this.close();
        this.input.focus();
      } else if (itemEl) {
        this.pressKeyOnItem(key, itemEl);
      } else if ((0, _closest["default"])(target, "." + INPUT)) {
        this.pressKeyOnInput(key);
      }
    }
    /**
     * Handle keydown events when it occurs on the Input
     * @param {string} key - key
     * @private
     */
    ;

    _proto.pressKeyOnInput = function pressKeyOnInput(key) {
      if (!this.opened) {
        this.open();
      } else if (key === 'arrowUp' || key === 'arrowDown') {
        this.dropdown.moveHighlightedItem(key === 'arrowUp' ? -1 : 1);
      }
    }
    /**
     * Handle keydown events when it occurs on the Item
     * @param {string} key - key
     * @param {HTMLElement} itemEl - Item.el
     * @private
     */
    ;

    _proto.pressKeyOnItem = function pressKeyOnItem(key, itemEl) {
      if (key === 'enter' || key === 'space') {
        this.selectByKeydown(itemEl);
      } else if (key === 'arrowUp' || key === 'arrowDown') {
        this.dropdown.moveHighlightedItem(key === 'arrowUp' ? -1 : 1);
      }
    }
    /**
     * Select an Item by space or enter
     * @param {HTMLElement} itemEl - Item.el
     * @private
     */
    ;

    _proto.selectByKeydown = function selectByKeydown(itemEl) {
      this.select(itemEl.getAttribute('data-value'));
      this.close();
      this.input.focus();
    }
    /**
     * Disable a select box, {@link ItemGroup item group} or {@link Item item}.
     * If it takes no arguments, a select box is disabled.
     * If it takes string, an item with the same value as the argument is disabled.
     * If it takes number, an item with the same index as the argument is disabled.
     * If it takes Item or ItemGroup, an argument itself is disabled.
     * @param {string|number|Item|ItemGroup} value - if string, find an Item by its value. if number, find an Item by its index.
     * @example
     * selectBox.disable(); // select box is disabled.
     * selectBox.disable(1); // second item is disabled.
     * selectBox.disable('value') // item which of value is 'value' is disabled.
     * selectBox.disable(selectBox.getSelectedItem()); // selected item is disabled.
     */
    ;

    _proto.disable = function disable(value) {
      if (!(0, _isExisty["default"])(value)) {
        this.disabled = true;
        this.input.disable();
        this.dropdown.disable();
        /**
         * Occurs when a select box, {@link ItemGroup item group} or {@link Item item} is disabled.
         * @event SelectBox#disable
         * @type {object} ev
         * @property {string} type - event name ('disable')
         * @property {SelectBox|ItemGroup|Item} target - disabled target
         * @example
         * selectBox.on('disable', ev => {
         *   console.log(ev.target);
         * });
         */

        this.fire('disable', {
          type: 'disable',
          target: this
        });
      } else if (value instanceof _item["default"] || value instanceof _itemGroup["default"]) {
        value.disable();
        this.fire('disable', {
          type: 'disable',
          target: value
        });
      } else {
        var disabledItem = this.dropdown.getItem(value);

        if (disabledItem) {
          disabledItem.disable();
          this.fire('disable', {
            type: 'disable',
            target: disabledItem
          });
        }
      }
    }
    /**
     * Enable a select box, {@link ItemGroup item group} or {@link Item item}.
     * If it takes no arguments, a select box is enabled.
     * If it takes string, an item with the same value as the argument is enabled.
     * If it takes number, an item with the same index as the argument is enabled.
     * If it takes Item or ItemGroup, an argument itself is enabled.
     * @param {string|number|Item|ItemGroup} value - if string, find an Item by its value. if number, find an Item by its index.
     * @example
     * selectBox.enable(); // select box is enabled.
     * selectBox.enable(1); // second item is enabled.
     * selectBox.enable('value') // item which of value is 'value' is enabled.
     * selectBox.enable(selectBox.getSelectedItem()); // selected item is enabled.
     */
    ;

    _proto.enable = function enable(value) {
      if (!(0, _isExisty["default"])(value)) {
        this.disabled = false;
        this.input.enable();
        this.dropdown.enable();
        /**
         * Occurs when a select box, {@link ItemGroup item group} or {@link Item item} is enabled.
         * @event SelectBox#enable
         * @type {object} ev
         * @property {string} type - event name ('enable')
         * @property {SelectBox|ItemGroup|Item} target - enable target
         * @example
         * selectBox.on('enable', ev => {
         *   console.log(ev.target);
         * });
         */

        this.fire('enable', {
          type: 'enable',
          target: this
        });
      } else if (value instanceof _item["default"] || value instanceof _itemGroup["default"]) {
        value.enable();
        this.fire('enable', {
          type: 'enable',
          target: value
        });
      } else {
        var disabledItem = this.dropdown.getItem(value);

        if (disabledItem) {
          disabledItem.enable();
          this.fire('enable', {
            type: 'enable',
            target: disabledItem
          });
        }
      }
    }
    /**
     * Open a dropdown list.
     * @example
     * selectBox.open();
     */
    ;

    _proto.open = function open() {
      if (!this.disabled) {
        this.opened = true;
        this.dropdown.open();
        this.input.open();
        /**
         * Occurs when a select box opens.
         * @event SelectBox#open
         * @property {string} type - event name ('open')
         * @example
         * selectBox.on('open', ev => {
         *   console.log('open');
         * });
         */

        this.fire('open', {
          type: 'open'
        });
      }
    }
    /**
     * Close a dropdown list.
     * @example
     * selectBox.close();
     */
    ;

    _proto.close = function close() {
      this.opened = false;
      this.dropdown.close();
      this.input.close();
      /**
       * Occurs when a select box closes.
       * @event SelectBox#close
       * @property {string} type - event name ('close')
       * @example
       * selectBox.on('close', ev => {
       *   console.log('close');
       * });
       */

      this.fire('close', {
        type: 'close'
      });
    }
    /**
     * Toggle a dropdown list.
     * @example
     * selectBox.toggle();
     */
    ;

    _proto.toggle = function toggle() {
      if (this.opened) {
        this.close();
      } else {
        this.open();
      }
    }
    /**
     * Select an {@link Item item}.
     * If it takes string, an item with the same value as the argument is selected.
     * If it takes number, an item with the same index as the argument is selected.
     * If it takes Item, an argument itself is selected.
     * @param {string|number|Item} value - if string, find an Item by its value. if number, find an Item by its index.
     * @return {Item} - selected Item.
     * @example
     * selectBox.select(1); // second item is selected.
     * selectBox.select('value') // item which of value is 'value' is selected.
     */
    ;

    _proto.select = function select(value) {
      var selectedItem = null;
      var prevSelectedItem = this.getSelectedItem();

      if (!this.disabled) {
        selectedItem = this.dropdown.select(value);

        if (selectedItem) {
          this.input.changeText(selectedItem);
          /**
           * Occurs when an {@link Item item} is selected.
           * @event SelectBox#select
           * @type {object} ev
           * @property {string} type - event name ('select')
           * @property {Item} target - selected item
           * @ignore
           * @example
           * selectBox.on('select', ev => {
           *   console.log(`${ev.target.getLabel()} is selected.`);
           * });
           */

          this.fire('select', {
            type: 'select',
            target: selectedItem
          });

          if (prevSelectedItem !== selectedItem) {
            /**
             * Occurs when a selected {@link Item item} is changed.
             * @event SelectBox#change
             * @type {object} ev
             * @property {string} type - event name ('change')
             * @property {Item} prev - previous selected item
             * @property {Item} curr - current selected item
             * @example
             * selectBox.on('change', ev => {
             *   console.log(`selected item is changed from ${ev.prev.getLabel()} to ${ev.curr.getLabel()}.`);
             * });
             */
            this.fire('change', {
              type: 'change',
              prev: prevSelectedItem,
              curr: selectedItem
            });
          }

          if (this.autoclose && this.opened) {
            this.close();
          }
        }
      }

      return selectedItem;
    }
    /**
     * Deselect an item.
     * If selectBox has a placeholder, the input's text is a placeholder.
     * If no placeholder, ths input is empty.
     * @example
     * selectBox.deselect();
     */
    ;

    _proto.deselect = function deselect() {
      if (!this.disabled) {
        this.dropdown.deselect();
        this.input.changeText();
      }
    }
    /**
     * Return the selected {@link Item item}.
     * @return {Item}
     */
    ;

    _proto.getSelectedItem = function getSelectedItem() {
      return this.dropdown.getSelectedItem();
    }
    /**
     * Get all {@link Item items} that pass the test implemented by the provided function.
     * If filter function is not passed, it returns all items.
     * @param {function} callback - callback function to filter items
     * @param {number} number - the number of items to find. If it is not passed, iterate all items.
     * @return {array<Item>}
     * @example
     * selectBox.getItems(); // all items
     * selectBox.getItems(item => {
     *  return !item.isDisabled();
     * }); // all enabled items
     */
    ;

    _proto.getItems = function getItems(callback, number) {
      return this.dropdown.getItems(callback, number);
    }
    /**
     * Get an {@link Item item} by its index or value.
     * @param {number|string} value - if string, the Item's value. if number, the Item's index.
     * @return {Item}
     * @example
     * selectBox.getItem(0); // first item
     * selectBox.getItem('value') // item which of value is 'value'
     */
    ;

    _proto.getItem = function getItem(value) {
      return this.dropdown.getItem(value);
    }
    /**
     * Get all {@link ItemGroup item groups} that pass the test implemented by the provided function.
     * If filter function is not passed, it returns all item groups.
     * @param {function} callback - callback function to filter item groups
     * @param {number} number - the number of items to find. If it is not passed, iterate all item groups.
     * @return {array<ItemGroup>}
     * @example
     * selectBox.getItemGroups(); // all item groups
     * selectBox.getItemGroups(itemGroup => {
     *  return !itemGroup.isDisabled();
     * }); // all enabled item groups
     */
    ;

    _proto.getItemGroups = function getItemGroups(callback, number) {
      return this.dropdown.getItemGroups(callback, number);
    }
    /**
     * Get an {@link ItemGroup item group} by its index.
     * @param {number} index - groupIndex of the ItemGroup
     * @return {ItemGroup}
     * @example
     * selectBox.getItemGroup(0); // first item group
     */
    ;

    _proto.getItemGroup = function getItemGroup(index) {
      return this.dropdown.getItemGroup(index);
    }
    /**
     * Destory a select box.
     * @example
     * selectBox.destroy();
     */
    ;

    _proto.destroy = function destroy() {
      this.unbindEvents();
      this.input.destroy();
      this.dropdown.destroy();

      if (this.theme) {
        this.theme.destroy();
      }

      (0, _removeElement["default"])(this.el);
      this.container = this.el = this.input = this.dropdown = this.theme = null;
    };

    return SelectBox;
  }();

  _customEvents["default"].mixin(SelectBox);

  var _default = SelectBox;
  _exports["default"] = _default;
});

/***/ }),

/***/ "./src/js/theme.js":
/*!*************************!*\
  !*** ./src/js/theme.js ***!
  \*************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports, __webpack_require__(/*! tui-code-snippet/collection/forEachOwnProperties */ "./node_modules/tui-code-snippet/collection/forEachOwnProperties.js"), __webpack_require__(/*! tui-code-snippet/domUtil/removeElement */ "./node_modules/tui-code-snippet/domUtil/removeElement.js"), __webpack_require__(/*! tui-code-snippet/type/isArray */ "./node_modules/tui-code-snippet/type/isArray.js"), __webpack_require__(/*! tui-code-snippet/type/isBoolean */ "./node_modules/tui-code-snippet/type/isBoolean.js"), __webpack_require__(/*! tui-code-snippet/type/isString */ "./node_modules/tui-code-snippet/type/isString.js"), __webpack_require__(/*! ./utils */ "./src/js/utils.js"), __webpack_require__(/*! ./constants */ "./src/js/constants.js"), __webpack_require__(/*! ./themeConfig */ "./src/js/themeConfig.js")], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports, _forEachOwnProperties, _removeElement, _isArray, _isBoolean, _isString, _utils, _constants, _themeConfig) {
  "use strict";

  _exports.__esModule = true;
  _exports["default"] = void 0;
  _forEachOwnProperties = _interopRequireDefault(_forEachOwnProperties);
  _removeElement = _interopRequireDefault(_removeElement);
  _isArray = _interopRequireDefault(_isArray);
  _isBoolean = _interopRequireDefault(_isBoolean);
  _isString = _interopRequireDefault(_isString);
  _themeConfig = _interopRequireDefault(_themeConfig);

  function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

  function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

  function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(source, true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(source).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

  function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

  /**
   * @class
   * @ignore
   * @param {object} customTheme - theme object for custom style
   * @param {HTMLElement|string} container - container element or selector
   */
  var Theme =
  /*#__PURE__*/
  function () {
    function Theme(customTheme, container) {
      this.containerSelector = (0, _utils.getSelector)(container);
      this.cssString = this.buildAll((0, _utils.transform)(customTheme));
      this.styleEl = this.createStyleElement();
      document.getElementsByTagName('head')[0].appendChild(this.styleEl);
    }
    /**
     * Create a style element
     * @return {HTMLElement}
     * @private
     */


    var _proto = Theme.prototype;

    _proto.createStyleElement = function createStyleElement() {
      var styleEl = document.createElement('style');
      styleEl.type = 'text/css';

      if (styleEl.styleSheet) {
        styleEl.styleSheet.cssText = this.cssString;
      } else {
        styleEl.appendChild(document.createTextNode(this.cssString));
      }

      return styleEl;
    }
    /**
     * Build css strings for Input, Dropdown, ItemGroup, and Item.
     * @param {object} theme - theme object
     * @return {string}
     * @private
     */
    ;

    _proto.buildAll = function buildAll(theme) {
      var exclude = {
        border: '',
        background: ''
      };
      return this.buildInput(_objectSpread({}, theme.common, {}, theme.input)) + this.buildDropdown(_objectSpread({}, theme.common, {
        borderTop: '0'
      }, theme.dropdown, {
        height: ''
      })) + this.buildItemGroup(theme.itemGroup ? _objectSpread({}, theme.common, {}, exclude, {}, theme.itemGroup.label) : _objectSpread({}, theme.common, {}, exclude)) + this.buildItem(theme.itemGroup ? _objectSpread({}, theme.common, {}, exclude, {}, theme.item, {
        inItemGroup: theme.itemGroup.items
      }) : _objectSpread({}, theme.common, {}, exclude, {}, theme.item));
    }
    /**
     * Build css strings for Input
     * @param {object} theme - theme object
     * @return {string}
     * @private
     */
    ;

    _proto.buildInput = function buildInput(theme) {
      theme.placeholder = {};

      if (theme.height) {
        theme.placeholder.lineHeight = theme.height;
      }

      if ((0, _isBoolean["default"])(theme.showIcon) && !theme.showIcon) {
        theme.icon = {
          display: 'none'
        };
        theme.placeholder.width = '100%';
      }

      return this.buildCssString(_constants.cls.INPUT, theme) + this.buildCssString([_constants.cls.INPUT, _constants.cls.OPEN], theme.open) + this.buildCssString([_constants.cls.INPUT, _constants.cls.DISABLED], theme.disabled) + this.buildCssString(_constants.cls.PLACEHOLDER, theme.placeholder) + this.buildCssString(_constants.cls.ICON, theme.icon);
    }
    /**
     * Build css strings for Dropdown
     * @param {object} theme - theme object
     * @return {string}
     * @private
     */
    ;

    _proto.buildDropdown = function buildDropdown(theme) {
      return this.buildCssString(_constants.cls.DROPDOWN, theme);
    }
    /**
     * Build css strings for ItemGroup
     * @param {object} theme - theme object
     * @return {string}
     * @private
     */
    ;

    _proto.buildItemGroup = function buildItemGroup(theme) {
      if (theme.height) {
        theme.lineHeight = theme.height;
      }

      return this.buildCssString(_constants.cls.ITEM_GROUP_LABEL, theme) + this.buildCssString([_constants.cls.ITEM_GROUP_LABEL, _constants.cls.DISABLED], theme.disabled);
    }
    /**
     * Build css strings for Item
     * @param {object} theme - theme object
     * @return {string}
     * @private
     */
    ;

    _proto.buildItem = function buildItem(theme) {
      if (theme.height) {
        theme.lineHeight = theme.height;
      }

      if (theme.selected) {
        var base = (0, _utils.transform)(_themeConfig["default"]);
        theme.selected = _objectSpread({}, base.item.selected, {}, theme.selected);
        theme.disabled = _objectSpread({}, base.item.disabled, {}, theme.disabled);
        theme.highlighted = _objectSpread({}, base.item.highlighted, {}, theme.highlighted);
      }

      return this.buildCssString(_constants.cls.ITEM, theme) + this.buildCssString([_constants.cls.ITEM, _constants.cls.SELECTED], theme.selected) + this.buildCssString([_constants.cls.ITEM, _constants.cls.DISABLED], theme.disabled) + this.buildCssString([_constants.cls.ITEM, _constants.cls.HIGHLIGHT], theme.highlighted) + this.buildCssString(_constants.cls.ITEM_GROUP + ">." + _constants.cls.ITEM, theme.inItemGroup);
    }
    /**
     * Build css strings
     * @param {string} className - className
     * @param {object} theme - theme object
     * @return {string}
     * @private
     */
    ;

    _proto.buildCssString = function buildCssString(className, theme) {
      if ((0, _isArray["default"])(className)) {
        className = className.join('.');
      }

      className = "." + className;
      var cssString = '';
      (0, _forEachOwnProperties["default"])(theme, function (value, key) {
        if ((0, _isString["default"])(value) && value) {
          key = key.replace(/([a-z0-9])([A-Z])/g, '$1-$2').toLowerCase();
          cssString += key + ":" + value + ";";
        }
      });
      return cssString ? this.containerSelector + " " + className + "{" + cssString + "}" : '';
    }
    /**
     * Destory a theme
     */
    ;

    _proto.destroy = function destroy() {
      (0, _removeElement["default"])(this.styleEl);
      this.styleEl = null;
    };

    return Theme;
  }();

  _exports["default"] = Theme;
});

/***/ }),

/***/ "./src/js/themeConfig.js":
/*!*******************************!*\
  !*** ./src/js/themeConfig.js ***!
  \*******************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports) {
  "use strict";

  _exports.__esModule = true;
  _exports["default"] = void 0;

  /**
   * @fileoverview Theme configuration
   * @author NHN FE Development Lab <dl_javascript@nhn.com>
   */

  /**
   * Theme configuration.
   * "common" prefix is for the entire select box. Its properties are overriden by "input", "dropdown", "itemGroup", and "item".
   * The example using theme can be found {@link tutorial-example02-theme here}.
   * @typedef {object} themeConfig
   * @example
   * const themeConfig = {
   *   'common.border': '1px solid #ddd', // border for input and dropdown (not itemGroup and item)
   *   'common.background': '#fff',
   *   'common.color': '#333',
   *   'common.width': '100%',
   *   'common.height': '29px', // height for item and itemGroup label (not entire select box)
   *
   *   'common.disabled.background': '#f9f9f9',
   *   'common.disabled.color': 'c8c8c8',
   *
   *   // Input
   *   'input.border': '1px solid #ddd',
   *   'input.borderBottom': '',
   *   'input.background': 'inherit',
   *   'input.color': '#333',
   *   'input.width': '100%',
   *   'input.height': '29px',
   *
   *   // Input when dropdown is open
   *   'input.open.border': '1px solid #aaa',
   *   'input.open.background': 'inherit',
   *   'input.open.color': '#333',
   *
   *   // Input when selectbox is disabled
   *   'input.disabled.border': '1px solid #aaa',
   *   'input.disabled.background': '#f9f9f9',
   *   'input.disabled.color': '#c8c8c8',
   *
   *   // Dropdown
   *   'dropdown.border': '1px solid #aaa',
   *   'dropdown.borderTop': '0',
   *   'dropdown.background': 'inherit',
   *   'dropdown.width': '100%',
   *   'dropdown.maxHeight': '',
   *
   *   // ItemGroup's items
   *   // if you want to set the same padding value as the itemGroup.label, set to '8px'.
   *   'itemGroup.items.paddingLeft': '20px',
   *
   *   // ItemGroup's label
   *   'itemGroup.label.border': '0',
   *   'itemGroup.label.background': 'inherit',
   *   'itemGroup.label.color': '#333',
   *   'itemGroup.label.fontWeight': 'bold',
   *   'itemGroup.label.height': '29px',
   *
   *   // disabled ItemGroup's label
   *   'itemGroup.label.disabled.border': '0',
   *   'itemGroup.label.disabled.background': 'inherit',
   *   'itemGroup.label.disabled.color': '#333',
   *
   *   // Item
   *   'item.border': '0',
   *   'item.background': 'inherit',
   *   'item.color': '#333',
   *   'item.height': '29px',
   *
   *   // selected Item
   *   'item.selected.border': '0',
   *   'item.selected.background': '#f4f4f4',
   *   'item.selected.color': '#333',
   *
   *   // disabled Item
   *   'item.disabled.border': '0',
   *   'item.disabled.background': '#f9f9f9',
   *   'item.disabled.color': '#c8c8c8',
   *
   *   // highlighted Item
   *   'item.highlighted.border': '0',
   *   'item.highlighted.background': '#e5f6ff',
   *   'item.highlighted.color': '#333'
   * };
   */
  var _default = {
    'common.border': '1px solid #ddd',
    // border for input and dropdown (not itemGroup and item)
    'common.background': '#fff',
    'common.color': '#333',
    'common.width': '100%',
    'common.height': '29px',
    // height for item and itemGroup label (not entire select box)
    'common.disabled.background': '#f9f9f9',
    'common.disabled.color': 'c8c8c8',
    // Input
    'input.border': '1px solid #ddd',
    'input.borderBottom': '',
    'input.background': 'inherit',
    'input.color': '#333',
    'input.width': '100%',
    'input.height': '29px',
    // Input when dropdown is open
    'input.open.border': '1px solid #aaa',
    'input.open.background': 'inherit',
    'input.open.color': '#333',
    // Input when selectbox is disabled
    'input.disabled.border': '1px solid #aaa',
    'input.disabled.background': '#f9f9f9',
    'input.disabled.color': '#c8c8c8',
    // Dropdown
    'dropdown.border': '1px solid #aaa',
    'dropdown.borderTop': '0',
    'dropdown.background': 'inherit',
    'dropdown.width': '100%',
    'dropdown.maxHeight': '',
    // ItemGroup's items
    'itemGroup.items.paddingLeft': '20px',
    // ItemGroup's label
    'itemGroup.label.border': '0',
    'itemGroup.label.background': 'inherit',
    'itemGroup.label.color': '#333',
    'itemGroup.label.fontWeight': 'bold',
    'itemGroup.label.height': '29px',
    // disabled ItemGroup's label
    'itemGroup.label.disabled.border': '0',
    'itemGroup.label.disabled.background': 'inherit',
    'itemGroup.label.disabled.color': '#333',
    // Item
    'item.border': '0',
    'item.background': 'inherit',
    'item.color': '#333',
    'item.height': '29px',
    // selected Item
    'item.selected.border': '0',
    'item.selected.background': '#f4f4f4',
    'item.selected.color': '#333',
    // disabled Item
    'item.disabled.border': '0',
    'item.disabled.background': '#f9f9f9',
    'item.disabled.color': '#c8c8c8',
    // highlighted Item
    'item.highlighted.border': '0',
    'item.highlighted.background': '#e5f6ff',
    'item.highlighted.color': '#333'
  };
  _exports["default"] = _default;
});

/***/ }),

/***/ "./src/js/utils.js":
/*!*************************!*\
  !*** ./src/js/utils.js ***!
  \*************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_ARRAY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (global, factory) {
  if (true) {
    !(__WEBPACK_AMD_DEFINE_ARRAY__ = [exports, __webpack_require__(/*! tui-code-snippet/collection/forEachOwnProperties */ "./node_modules/tui-code-snippet/collection/forEachOwnProperties.js"), __webpack_require__(/*! tui-code-snippet/type/isString */ "./node_modules/tui-code-snippet/type/isString.js")], __WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.apply(exports, __WEBPACK_AMD_DEFINE_ARRAY__)) : __WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
  } else { var mod; }
})(this, function (_exports, _forEachOwnProperties, _isString) {
  "use strict";

  _exports.__esModule = true;
  _exports.getSelector = _exports.createElement = _exports.transform = void 0;
  _forEachOwnProperties = _interopRequireDefault(_forEachOwnProperties);
  _isString = _interopRequireDefault(_isString);

  function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

  /**
   * @fileoverview Utility functions
   * @author NHN. FE dev team.<dl_javascript@nhn.com>
   */

  /**
   * Transform an object using dot notation
   * @param {object} obj - object to transform
   * @return {object}
   */
  var transform = function transform(obj) {
    var result = {};
    (0, _forEachOwnProperties["default"])(obj, function (value, prop) {
      var keys = prop.split('.');
      var curr = result;
      keys.forEach(function (key, index) {
        if (index === keys.length - 1) {
          curr[key] = value;
        } else if (!curr[key]) {
          curr[key] = {};
        }

        curr = curr[key];
      });
    });
    return result;
  };
  /**
   * Create a HTML element
   * @param {string} tagName - tag name
   * @param {string} content - content in the element
   * @param {object} options - other properties for the element
   * @param {HTMLElement} container - parent element for the element
   * @return {HTMLElement}
   */


  _exports.transform = transform;

  var createElement = function createElement(tagName, content, options, container) {
    var el = document.createElement(tagName);

    if (content) {
      el.innerText = content;
    }

    (0, _forEachOwnProperties["default"])(options, function (value, key) {
      if (key.indexOf('data-') > -1) {
        el.setAttribute(key, value);
      } else {
        el[key] = value;
      }
    });

    if (container) {
      container.appendChild(el);
    }

    return el;
  };
  /**
   * Get selectors for an element
   * @param {HTMLElement} el - element
   * @return {string}
   */


  _exports.createElement = createElement;

  var getSelector = function getSelector(el) {
    if ((0, _isString["default"])(el)) {
      return el;
    }

    if (el.id) {
      return "#" + el.id;
    }

    var className = "." + el.className.replace(/\s+/g, '.');

    if (className) {
      var elems = document.querySelectorAll(className);

      if (elems.length === 1) {
        return className;
      }
    }

    var tagName = el.tagName.toLowerCase();
    return "" + tagName + className;
  };

  _exports.getSelector = getSelector;
});

/***/ })

/******/ })["default"];
});
