<?php

namespace App\Http\Controllers\Slotlayer;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests; 
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Specialtactics\L5Api\Http\Controllers\RestfulController as BaseController;
use Illuminate\Http\Request;
use Validator;
use Illuminate\Support\Facades\Http;
use App\Models\Slotlayer\Gameoptions;
use App\Models\Slotlayer\GameoptionsParent;
use App\Models\Slotlayer\DemoSessions;
use App\Models\Slotlayer\CurrencyPrices;
use App\Models\Slotlayer\RegularSessions;
use App\Models\Slotlayer\AccessProfiles;
use App\Models\Slotlayer\GametransactionsLive;
use App\Models\Slotlayer\CallbackErrors;
use \Cache;
use Carbon\Carbon;
use Illuminate\Support\Facades\Log;
use Dingo\Api\Routing\Helpers;
use Dingo\Api\Http\Response;
use Illuminate\Support\Facades\Crypt;
use App\Http\Controllers\Slotlayer\EvoplayController;
use DB;

class APIGameController extends \App\Http\Controllers\Controller
{
    public static function createRandomVal($val) {
        $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        srand((double)microtime() * 1000000);
        $i = 0;
        $pass = '';
        while ($i < $val) {
            $num = rand() % 64;
            $tmp = substr($chars, $num, 1);
            $pass = $pass . $tmp;
            $i++;
        }
        return $pass;
    }

    public static function encryptCasinoToken($plaintext, $password) 
     {
        //self::decryptCasinoToken(hex2bin($encryptedPID), $decryptID)
        $method = "AES-256-CBC";
        $key = hash('sha256', $password, true);
        $iv = openssl_random_pseudo_bytes(16);

        $ciphertext = openssl_encrypt($plaintext, $method, $key, OPENSSL_RAW_DATA, $iv);
        $hash = hash_hmac('sha256', $ciphertext . $iv, $key, true);

        return $iv . $hash . $ciphertext;
    }

   /**
     * @param Game URL generation, this should be done in a seperated instance - this is merely to showcase functionallity.
     * @return \Illuminate\Http\JsonResponse
     */
    public function gameURLRequest(Request $request)
    {
        $ip = $request->header('CF-Connecting-IP');
        if($ip === NULL || !$ip) {
            $ip = $_SERVER['REMOTE_ADDR'];
        }

        $gameList = DB::table('gamelist')->get();
        $game = $request->game;
        $player = $request->userid;
        $currency = $request->currency;
        $mode = $request->mode;

        $selectGame = $gameList->where('game_id', $request->game)->first();


        if(!$selectGame) {
            return response()->json([
                'status' => 404,
                'error' => 'Game not found.',
                'request_ip' => $ip
            ])->setStatusCode(404);
        }

        $gameprovider = $selectGame->game_provider;


        if($gameprovider === 'evoplay') {
                $createLink = EvoplayController::createSlots($player, $selectGame->game_id, $selectGame->extra_id, '1', $mode, $currency);
                $url = $createLink['url'];
        }


	return response()->json([
		'url' => $url
	]);

    }



}


