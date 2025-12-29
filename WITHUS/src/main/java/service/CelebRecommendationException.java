// package service;

package service;

import java.io.Serializable;

public class CelebRecommendationException extends Exception implements Serializable {
    private static final long serialVersionUID = 1L;

    private String code;

    public CelebRecommendationException(String code, String message) {
        super(message);
        this.code = code;
    }

    public String getCode() {
        return code;
    }
}