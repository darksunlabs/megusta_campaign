// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Campaign {

    struct record {
        uint rid; //the record id
        uint scr; //the score
        uint ts;  // the timestamp
    }

    uint count = 0;
    
    mapping (uint => string) public entries;
    mapping (string => record) public scores;
    mapping (uint => address) public best;
    mapping (uint => uint) public bestscores;

    
    function register(uint score, uint game) public {
        require (game == 1 || game == 2, "game id is 1 or 2 only");
        string memory b = string.concat(Strings.toHexString(uint256(uint160(msg.sender)), 20), Strings.toString(game));
        record storage r = scores[b]; 
        if (r.scr == 0){
            uint c = count + 1;
            record memory s = record({
                rid: c,
                scr: score,
                ts: block.timestamp
            });
            scores[b] = s;
            entries[c] = b;
            
            count = c;
            if (bestscores[game] < score){
                bestscores[game] = score;
                best[game] = msg.sender;
            }
        }
        else if (r.scr < score){
            uint prev = r.rid;
            record memory s = record({
                rid: prev,
                scr: score,
                ts: block.timestamp
            });
            scores[b] = s;
            entries[prev] = b;
            if (bestscores[game] < score){
                bestscores[game] = score;
                best[game] = msg.sender;
            }
        }
    }


    function fetch_myscore(uint gid) public view returns (uint){
        string memory b = string.concat(Strings.toHexString(uint256(uint160(msg.sender)), 20), Strings.toString(gid));
        record memory rec = scores[b];
        return rec.scr;
    }

    function fetch_mytime(uint gid) public view returns (uint){
        string memory b = string.concat(Strings.toHexString(uint256(uint160(msg.sender)), 20), Strings.toString(gid));
        record memory rec = scores[b];
        return rec.ts;
    }

    
    function fetch_best(uint gid) public view returns (address){
        address bst = best[gid];
        return bst;
    }

    function fetch_bestscore(uint gid) public view returns (uint){
        uint bstscr = bestscores[gid];
        return bstscr;
    }

    
}
