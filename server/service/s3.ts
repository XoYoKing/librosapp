///<reference path='../types.ts'/>

import knox = module('knox')
import q = module('q')

export interface Store {
  fileUploadAndSetUrl(file:IFile, source:IUploadFile):q.IPromise;
  fileRemove(file:IFile):q.IPromise;
  remove(remotePath:string):q.IPromise;
  upload(remotePath:string, source:IUploadFile):q.IPromise;
  fullUrl(remotePath:string):string;
  ext(source:IUploadFile):string;
}

var BUCKET = "librosapp"
var BUCKET_URL = "http://" + BUCKET + ".s3.amazonaws.com"
var s3client = knox.createClient({
  key:"AKIAIMGQVHF2DZ7UN32Q",                         // DELETE ME (belongs to scott)
  secret:"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",
  bucket:BUCKET,
})

export function fileUploadAndSetUrl(file:IFile, source:IUploadFile) {
  return upload(fileToUrlPath(file), source)
  .then(function() {
    file.url = fileToUrl(file)
    return file
  })
}

export function fileRemove(file:IFile):q.IPromise {
  return remove(fileToUrlPath(file))
}

export function upload(remotePath:string, source:IUploadFile) {
  var deferred = q.defer()
  s3client.putFile(source.path, remotePath, {'Content-Type':source.mime}, <knox.IResponseCallback> deferred.makeNodeResolver())
  return deferred.promise
}

export function remove(remotePath:string) {
  var deferred = q.defer()
  s3client.deleteFile(remotePath, <knox.IResponseCallback> deferred.makeNodeResolver())
  return deferred.promise
}

export function fullUrl(remotePath:string) {
  return BUCKET_URL + remotePath
}

function fileToUrl(file:IFile):string {
  return fullUrl(fileToUrlPath(file))
}

// need more info that that! need the extention, etc
function fileToUrlPath(file:IFile):string {
  return "/" + file.fileId + "." + file.ext
}

export function ext(source:IUploadFile):string {
  return source.name.match(/\.(\w+)$/)[1]
}


