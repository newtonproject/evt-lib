// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.9;

library EVTMetadata {
    struct Media {
        string data;
        string contentType;
        string protocol;
    }

    struct IPFSFile {

        // CID is the content identifier for this IPFS file.
        //
        // Ref: https://docs.ipfs.io/concepts/content-addressing/
        //
        string cid;

        // Path is an optional path to the file resource in an IPFS directory.
        //
        // This field is only needed if the file is inside a directory.
        //
        // Ref: https://docs.ipfs.io/concepts/file-systems/
        //
        string path;
    }

    // For EVT Display
    struct Display {
        // The name of the object. 
        //
        // This field will be displayed in lists and therefore should
        // be short an concise.
        //
        string name;
    
        // A written description of the object. 
        //
        // This field will be displayed in a detailed view of the object,
        // so can be more verbose (e.g. a paragraph instead of a single line).
        //
        string description;
    
        // A small thumbnail representation of the object.
        IPFSFile thumbnail;

        // legal license of the object.
        string license;

        string from;

        string symbol;

        IPFSFile logo;
    }

    struct IPFSImage {
        string url;
        string ipfsHash;
        string width;
        string height;
        string contentType;
    }

    struct IPFSVideo {
        string url;
        string ipfsHash;
        string width;
        string height;
        string codec;
        string container;
        string contentType;
    }

    struct IPFS3DModel {
        string url;
        string ipfsHash;
        string length;
        string width;
        string height;
        string container;
        string contentType; // option: obj, gltf, fbx, glb
        string version;
    }

    struct EncryptedKey {
        string protocol; // option: newinfo@v1
        string method; // options: AES-128
        string encryptedValue;
    }

}
